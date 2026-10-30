#!/bin/bash
# Muestra el estado resumido de las VMs en ejecución

VBoxManage list runningvms | sed 's/^"\(.*\)" {.*}$/\1/' | while IFS= read -r vm; do
  printf "\n=== VM: %s ===\n" "$vm"
  VBoxManage showvminfo "$vm" --machinereadable | awk -F= '
    /^[[:space:]]*#/ { next }
    {
      key = $1
      if (key ~ /^(VMState|ostype|memory|cpus|cpuexecutioncap|chipset|firmware|nestedpaging|HWVirtEx|nic[0-9]+|bridgeadapter[0-9]+|macaddress[0-9]+|cableconnected[0-9]+|.*-ImageUUID-[0-9]+-[0-9]+|.*-[0-9]+-[0-9]+)$/)
        print
    }
  '
done
