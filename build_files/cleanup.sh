#!/usr/bin/bash
set -euo pipefail

trap '[[ $BASH_COMMAND != echo* ]] && [[ $BASH_COMMAND != log* ]] && echo "+ $BASH_COMMAND"' DEBUG

log() {
  echo "=== $* ==="
}

log "Starting system cleanup"

# fix os-release
cat /usr/lib/os-release
sed -i "s/^ID=fedora/ID=codeos\nID_LIKE=\"fedora\"/" /usr/lib/os-release
cat /usr/lib/os-release

# Remove autostart files
rm /etc/skel/.config/autostart/steam.desktop

# Clean package manager cache
dnf5 clean all

# Clean temporary files
rm -rf /tmp/*

# Clean /var directory while preserving essential files
find /var/* -maxdepth 0 -type d \! -name cache -exec rm -fr {} \;
find /var/cache/* -maxdepth 0 -type d \! -name libdnf5 \! -name rpm-ostree -exec rm -fr {} \;

# Restore and setup directories
mkdir -p /var/tmp
chmod -R 1777 /var/tmp

# Commit and lint container
ostree container commit
bootc container lint

log "Cleanup completed"
