#!/bin/bash

SESSION="monitor"
DEFAULT_INTERVAL=30

# Socket propio para esta instancia: aísla el servidor tmux del de otras máquinas/ejecuciones
TMUX_SOCKET="monitor_$$"

# El directorio de estado también depende del socket, para que el flag de pausa
# sea independiente por instancia. Si dos máquinas comparten /tmp (contenedores,
# NFS, etc.) o ejecutas dos veces en el mismo host, cada una tiene su propio flag.
STATE_DIR="/tmp/monitor_tmux_$$"
PAUSE_FLAG="$STATE_DIR/cycle_paused"

# Wrapper para no repetir -L en cada llamada
tmux_cmd() {
  tmux -L "$TMUX_SOCKET" "$@"
}

# Función de confirmación: pregunta por /dev/tty para que funcione con sudo
confirm() {
  local prompt="$1"
  local reply
  if [ ! -t 0 ] && [ ! -e /dev/tty ]; then
    return 1
  fi
  read -r -p "$prompt [s/N] " reply < /dev/tty
  case "$reply" in
    [sSyY]) return 0 ;;
    *)      return 1 ;;
  esac
}

# Preguntar el intervalo del ciclo (Enter = valor por defecto)
CYCLE_INTERVAL="$DEFAULT_INTERVAL"
if [ -e /dev/tty ]; then
  read -r -p "Intervalo del ciclo en segundos [$DEFAULT_INTERVAL]: " input_interval < /dev/tty
  if [ -n "$input_interval" ]; then
    if [[ "$input_interval" =~ ^[0-9]+$ ]] && [ "$input_interval" -gt 0 ]; then
      CYCLE_INTERVAL="$input_interval"
    else
      echo "Valor inválido. Se usará el valor por defecto: $DEFAULT_INTERVAL segundos."
    fi
  fi
fi
echo "Intervalo del ciclo: $CYCLE_INTERVAL segundos"
echo "Socket tmux: $TMUX_SOCKET"
echo "Directorio de estado: $STATE_DIR"

# Crear directorio de estado si no existe
mkdir -p "$STATE_DIR"

# Preguntar antes de borrar el flag de pausa
if [ -f "$PAUSE_FLAG" ]; then
  if confirm "Existe '$PAUSE_FLAG'. ¿Borrar el flag de pausa?"; then
    rm -f "$PAUSE_FLAG"
    echo "Flag de pausa borrado."
  else
    echo "Se conserva el flag de pausa (el ciclo arrancará pausado)."
  fi
fi

# Preguntar antes de matar SOLO la sesión monitor (no todo el servidor)
if tmux_cmd has-session -t "$SESSION" 2>/dev/null; then
  if confirm "Ya existe la sesión tmux '$SESSION' en el socket '$TMUX_SOCKET'. ¿Matarla?"; then
    tmux_cmd kill-session -t "$SESSION" 2>/dev/null
    sleep 1
  else
    echo "Abortando: no se puede continuar sin matar la sesión existente."
    exit 1
  fi
fi

# 1) Crear la sesión PRIMERO: esto arranca el servidor y lo mantiene vivo
tmux_cmd new-session -d -s "$SESSION" -n "btop"

# 2) Configurar TODO contra el servidor vivo

# Keybindings globales (tabla prefix)
tmux_cmd bind-key Right "next-window; run-shell 'touch \"$PAUSE_FLAG\"'"
tmux_cmd bind-key Left  "previous-window; run-shell 'touch \"$PAUSE_FLAG\"'"
tmux_cmd set-option -g mouse on

for i in {0..7}; do
  tmux_cmd bind-key "$i" "select-window -t :$i; run-shell 'touch \"$PAUSE_FLAG\"'"
done

tmux_cmd bind-key Space "run-shell \"if [ -f '$PAUSE_FLAG' ]; then rm -f '$PAUSE_FLAG'; tmux -L $TMUX_SOCKET display-message '▶ Reanudado'; else touch '$PAUSE_FLAG'; tmux -L $TMUX_SOCKET display-message '⏸ Pausado'; fi\""
tmux_cmd bind-key w list-windows
tmux_cmd bind-key q kill-session
tmux_cmd bind-key '?' list-keys

# 3) Llenar las ventanas: primero new-window, luego send-keys

# Ventana 0: btop (ya existe por new-session -n "btop")
tmux_cmd send-keys -t "$SESSION:0" "btop" Enter

# Ventana 1: journalctl
tmux_cmd new-window -t "$SESSION" -n "journalctl"
tmux_cmd send-keys -t "$SESSION:1" "journalctl -f -n 500 | ccze -A -o lookups=off" Enter

# Ventana 2: apache access
tmux_cmd new-window -t "$SESSION" -n "apache access"
tmux_cmd send-keys -t "$SESSION:2" "tail -f -n 500 /var/log/httpd/access_log | ccze -A -o lookups=off" Enter

# Ventana 3: apache errors
tmux_cmd new-window -t "$SESSION" -n "apache errors"
tmux_cmd send-keys -t "$SESSION:3" "tail -f /var/log/httpd/error_log | ccze -A -o lookups=off" Enter

# Ventana 4: php errors
tmux_cmd new-window -t "$SESSION" -n "php errors"
tmux_cmd send-keys -t "$SESSION:4" "tail -f -n 500 /var/log/php-fpm/www-error.log | ccze -A -o lookups=off" Enter

# Ventana 5: auth (Fedora)
tmux_cmd new-window -t "$SESSION" -n "ssh errors"
tmux_cmd send-keys -t "$SESSION:5" "sudo tail -f /var/log/secure | ccze -A -o lookups=off" Enter

# Ventana 6: puertos
tmux_cmd new-window -t "$SESSION" -n "puertos"
tmux_cmd send-keys -t "$SESSION:6" "ss -tlnp | ccze -A -o lookups=off" Enter

# Ventana 7: nethogs
tmux_cmd new-window -t "$SESSION" -n "nethogs"
tmux_cmd send-keys -t "$SESSION:7" "sudo nethogs -b" Enter

# 4) Seleccionar ventana 0
tmux_cmd select-window -t "$SESSION:0"

# 5) Ciclo automático (usa el socket correcto)
(
  while true; do
    sleep 1
    if [ ! -f "$PAUSE_FLAG" ]; then
      sleep $((CYCLE_INTERVAL - 1))
      if [ ! -f "$PAUSE_FLAG" ]; then
        tmux -L "$TMUX_SOCKET" next-window -t "$SESSION" 2>/dev/null || break
      fi
    fi
  done
) &
CYCLE_PID=$!

# 6) Adjuntar
tmux_cmd attach-session -t "$SESSION"

kill "$CYCLE_PID" 2>/dev/null

# Preguntar antes de borrar el directorio de estado
if [ -d "$STATE_DIR" ]; then
  if confirm "¿Borrar el directorio de estado '$STATE_DIR'?"; then
    rm -rf "$STATE_DIR"
    echo "Directorio de estado borrado."
  else
    echo "Se conserva '$STATE_DIR'."
  fi
fi
