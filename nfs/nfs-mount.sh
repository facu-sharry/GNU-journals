#!/bin/bash

set -euo pipefail

# Prerequisites:
# - NFS server must be set up and running
# - NFS exports must be configured on the server
# - Client machine must have NFS client utilities installed
# - Client machine must have network connectivity to the NFS server
# - Client machine must have appropriate permissions to access the NFS shares
# - NFS server IP address, exported directories, and local mount points must be defined in .env file


SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [ ! -f "$SCRIPT_DIR/.env" ]; then
    echo "Error: .env file not found in $SCRIPT_DIR"
    exit 1
fi
source "$SCRIPT_DIR/.env"

if [ -z "$NFS_SERVER" ] || [ -z "$NFS_DISKS" ] || [ -z "$MOUNT_POINTS" ]; then
    echo "Error: NFS_SERVER, NFS_DISKS, and MOUNT_POINTS must be set in .env"
    exit 1
fi

# Retrieve argument from command line
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <option>"
    echo "Options:"
    echo "  mount   - Mount NFS shares"
    echo "  umount  - Unmount NFS shares"
    exit 1
fi

# If the argument is "umount", lets unmount the NFS shares and exit
if [ "$1" == "umount" ]; then
    for MOUNT_POINT in "${MOUNT_POINTS[@]}"; do
        if mountpoint -q "${MOUNT_POINT#*:}"; then
            echo "Unmounting ${MOUNT_POINT#*:}..."
            sudo umount "${MOUNT_POINT#*:}"
        else
            echo "Mount point ${MOUNT_POINT#*:} is not mounted, skipping."
        fi
    done
    echo "NFS unmount complete!"
    exit 0
fi

if [ "$1" != "mount" ]; then
    echo "Invalid option: $1"
    echo "Usage: $0 <option>"
    echo "Options:"
    echo "  mount   - Mount NFS shares"
    echo "  umount  - Unmount NFS shares"
    exit 1
fi


# Create mount points if they don't exist
for MOUNT_POINT in "${MOUNT_POINTS[@]}"; do
    if [ ! -d "${MOUNT_POINT#*:}" ]; then
        echo "Creating mount point: ${MOUNT_POINT#*:}"
        sudo mkdir -p "${MOUNT_POINT#*:}"
    fi
done

# Mount NFS shares
echo "Mounting NFS shares from $NFS_SERVER..."
for ((i=0; i<${#NFS_DISKS[@]}; i++)); do
    NFS_SHARE=$(echo "${NFS_DISKS[$i]}" | cut -d':' -f2)
    MOUNT_POINT=$(echo "${MOUNT_POINTS[$i]}" | cut -d':' -f2)
    sudo mount "$NFS_SERVER:$NFS_SHARE" "$MOUNT_POINT"
done

echo "NFS mounts complete!"
mount | grep nfs
