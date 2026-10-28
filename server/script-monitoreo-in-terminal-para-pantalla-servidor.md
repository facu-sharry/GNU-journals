# Script monitoreo in-terminal para pantalla servidor

# Documentación: Script de Monitoreo con tmux

## 1. Instalación de Dependencias

El script utiliza `tmux` como base, `btop` para monitoreo de recursos y `ccze` para colorear logs. Ejecuta el bloque correspondiente a tu sistema operativo.

### Debian / Ubuntu (Hipervisor)

```bash
sudo apt update
sudo apt install -y tmux btop ccze nethogs iftop duf
```

### Fedora (VM de Servidores Web)

```bash
sudo dnf install -y tmux btop nethogs iftop ccze duf
```

**Nota sobre `ccze` en Fedora:** El paquete `ccze` no está en los repositorios base de Fedora, sino en **EPEL**. Si no lo tienes habilitado, ejecuta primero `sudo dnf install epel-release` y luego `sudo dnf install ccze` . Si prefieres no usar EPEL, puedes omitir `ccze` o compilar desde fuente.

---

## 2. Script `monitor.sh`

Crea el archivo, pégalo y dale permisos de ejecución.

```bash
...
```

```bash
chmod +x monitor.sh
sudo ./monitor.sh
```

---

## 3. Colocacion en servidor (Installing a Script to `/usr/local/bin`)

### Step 1: Verify the script works
Test your script from its current location to ensure it runs correctly:
```bash
sudo ~/Documentos/monitor.sh
```

Check for any errors and confirm the tmux session starts as expected.

---

### Step 2: Copy the script to `/usr/local/bin`
```bash
sudo cp ~/Documentos/monitor.sh /usr/local/bin/monitor
```

**Note:** Omit the `.sh` extension for CLI tools — this makes the command cleaner (`monitor` instead of `monitor.sh`).

---

### Step 3: Make it executable
```bash
sudo chmod +x /usr/local/bin/monitor
```

Verify permissions:
```bash
ls -l /usr/local/bin/monitor
```

You should see something like:
```
-rwxr-xr-x 1 root root 2048 Oct 27 10:30 /usr/local/bin/monitor
```

---

### Step 4: Test the installed script
Run it from anywhere without the path:
```bash
sudo monitor
```

It should behave identically to the original.

---

### Step 5: (Optional) Add to `sudoers` for passwordless execution
If you want to run `sudo monitor` without entering your password each time:

```bash
sudo visudo
```

Add this line at the end (replace `puestof01` with your actual username):
```
puestof01 ALL=(ALL) NOPASSWD: /usr/local/bin/monitor
```

Save and exit (Ctrl+X in nano, or `:wq` in vi).

**Test it:**
```bash
sudo monitor
```

It should run without prompting for a password.

---

### Step 6: Verify it's in `$PATH`
Confirm the system can find it:
```bash
which monitor
```

Should output:
```
/usr/local/bin/monitor
```

---

### Uninstalling (if needed)
```bash
sudo rm /usr/local/bin/monitor
```

---

That's it — your script is now a system-wide CLI tool!

---

## 3. Uso y Keybinds

El prefix está configurado como **`Ctrl+B`**.

| Acción | Keybind |
| :--- | :--- |
| Próxima ventana (y pausar ciclo) | `Ctrl+B`, `→` |
| Ventana anterior (y pausar ciclo) | `Ctrl+B`, `←` |
| Ir a ventana N (0-7) | `Ctrl+B`, `N` |
| Pausar / Reanudar ciclo | `Ctrl+B`, `Espacio` |
| Listar ventanas | `Ctrl+B`, `W` |
| Cerrar sesión | `Ctrl+B`, `Q` |
| Listar comandos (ayuda) | `Ctrl+B`, `?` |

### Modo Copia (Scroll y Búsqueda)

Como el prefix es `Ctrl+B`, la secuencia es:

1.  **Entrar:** `Ctrl+B` y luego `[`.
2.  **Navegar:** Usa las flechas o `Page Up`/`Page Down`. Si configuraste `mode-keys vi`, también funcionan `h/j/k/l`.
3.  **Buscar:** Presiona `/`, escribe el término y Enter. Usa `n` / `N` para saltar entre resultados .
4.  **Salir:** Presiona `q`.

---

## 4. Notas Críticas por Sistema Operativo

### Rutas de Log

| Log | Ubuntu / Debian (Hipervisor) | Fedora (VM Web) |
| :--- | :--- | :--- |
| **Auth / SSH** | `/var/log/auth.log` | `/var/log/secure` |
| **Apache Access** | `/var/log/apache2/access.log` | `/var/log/httpd/access.log` |
| **Apache Error** | `/var/log/apache2/error.log` | `/var/log/httpd/error_log` |
| **PHP-FPM Error** | `/var/log/php*-fpm.log` | `/var/log/php-fpm/www-error.log` |

Ajusta las líneas de `send-keys` en el script según corresponda. El script de ejemplo ya está preparado para Fedora (Apache).

### Coloreado con `ccze`

Solo añade `| ccze -A` al final de los comandos `tail -f` o `journalctl -f` (como se muestra en el script). El flag `-A` fuerza la salida de colores ANSI para que tmux los renderice correctamente .

---

## 5. Plantillas de Apps por Servidor

Rellena estos bloques con las rutas y programas específicos de cada máquina.

### Web
```bash
# Ventana 0: btop (ya existe por new-session -n "btop")
tmux send-keys -t "$SESSION:0" "btop" Enter

# Ventana 1: journalctl
tmux new-window -t "$SESSION" -n "journalctl"
tmux send-keys -t "$SESSION:1" "journalctl -f -n 500 | ccze -A" Enter

# Ventana 2: apache access
tmux new-window -t "$SESSION" -n "apache access"
tmux send-keys -t "$SESSION:2" "tail -f -n 500 /var/log/httpd/access.log | ccze -A" Enter

# Ventana 3: apache errors
tmux new-window -t "$SESSION" -n "apache errors"
tmux send-keys -t "$SESSION:3" "tail -f /var/log/httpd/www.error.log | ccze -A" Enter

# Ventana 4: php errors
tmux new-window -t "$SESSION" -n "php errors"
tmux send-keys -t "$SESSION:4" "tail -f -n 500 /var/log/php-fpm/www.error.log | ccze -A" Enter

# Ventana 5: auth (Fedora)
tmux new-window -t "$SESSION" -n "ssh errors"
tmux send-keys -t "$SESSION:5" "sudo tail -f /var/log/secure | ccze -A" Enter

# Ventana 6: puertos web + minecraft
tmux new-window -t "$SESSION" -n "puertos"
tmux send-keys -t "$SESSION:6" "watch -n 2 'ss -tlnp | grep -E \":(80|443|25565)\"'" Enter

# Ventana 7: nethogs
tmux new-window -t "$SESSION" -n "nethogs"
tmux send-keys -t "$SESSION:7" "sudo nethogs -b | ccze -A" Enter
```

### Web 2
```bash
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
tmux_cmd send-keys -t "$SESSION:3" "tail -f -n 500 /var/log/httpd/error_log | ccze -A -o lookups=off" Enter

# Ventana 4: php errors
tmux_cmd new-window -t "$SESSION" -n "php errors"
tmux_cmd send-keys -t "$SESSION:4" "tail -f -n 500 /var/log/php-fpm/www-error.log | ccze -A -o lookups=off" Enter

# Ventana 5: auth (Fedora)
tmux_cmd new-window -t "$SESSION" -n "ssh errors"
tmux_cmd send-keys -t "$SESSION:5" "sudo tail -f -n 500 /var/log/secure | ccze -A -o lookups=off" Enter

# Ventana 6: puertos
tmux_cmd new-window -t "$SESSION" -n "puertos"
tmux_cmd send-keys -t "$SESSION:6" "ss -tlnp | ccze -A -o lookups=off" Enter

# Ventana 7: nethogs
tmux_cmd new-window -t "$SESSION" -n "nethogs"
tmux_cmd send-keys -t "$SESSION:7" "sudo nethogs -b" Enter
```

### Ubuntu DataStorage (Hipervisor)
```bash
# (Comandos de instalación y bloque de send-keys específico)
```

### DNS
```bash
# (Comandos de instalación y bloque de send-keys específico)
```

### 250
```bash
# (Comandos de instalación y bloque de send-keys específico)
```

### Backups
```bash
# (Comandos de instalación y bloque de send-keys específico)
```
