#!/bin/bash
# Ceph Cluster Cleanup Script
# Usage: ./cleanup_ceph.sh [bootstrap-node]

set -euo pipefail

CEPH_USER="auden"
declare -A NODE_IPS=(
    ["c1"]="192.168.1.21"
    ["c2"]="192.168.1.22"
    ["c4"]="192.168.1.24"
)
declare -A SSH_PORTS=(
    ["c1"]="22"
    ["c2"]="22"
    ["c4"]="22"
)
OSD_DEVICE="/dev/sdc"

function cleanup_ceph_services() {
    local node=$1
    local ip=${NODE_IPS[$node]}
    local port=${SSH_PORTS[$node]}

    echo "=== purge node $node ceph service ==="
    
    ssh -p "$port" "${CEPH_USER}@${ip}" "
        sudo systemctl stop 'ceph-*' || true
        sudo systemctl disable 'ceph-*' || true
        sudo systemctl reset-failed 'ceph-*' || true
        sudo pkill -f ceph || true
    "
}

function remove_ceph_data() {
    local node=$1
    local ip=${NODE_IPS[$node]}
    local port=${SSH_PORTS[$node]}

    echo "=== purge node $node ceph data ==="
    
    ssh -p "$port" "${CEPH_USER}@${ip}" "
        sudo rm -rf /etc/ceph
        sudo rm -rf /var/lib/ceph
        sudo rm -rf /var/log/ceph
        sudo rm -rf /etc/systemd/system/ceph-*.service
        sudo rm -rf /etc/systemd/system/ceph.target.wants
        sudo systemctl daemon-reload
    "
}

function cleanup_osd_device() {
    local node=$1
    local ip=${NODE_IPS[$node]}
    local port=${SSH_PORTS[$node]}

    echo "=== purge node $node osd device $OSD_DEVICE ==="
    
    ssh -p "$port" "${CEPH_USER}@${ip}" "
        sudo sgdisk --zap-all $OSD_DEVICE
        sudo dd if=/dev/zero of=$OSD_DEVICE bs=1M count=100
        sudo blkdiscard $OSD_DEVICE || true
        sudo partprobe $OSD_DEVICE
    "
}

function uninstall_packages() {
    local node=$1
    local ip=${NODE_IPS[$node]}
    local port=${SSH_PORTS[$node]}

    echo "=== uninstall node $node ceph package ==="
    
    ssh -p "$port" "${CEPH_USER}@${ip}" "
        sudo apt-get purge -y cephadm
        sudo apt-get autoremove -y
        sudo rm -rf /etc/apt/sources.list.d/ceph.list
        sudo apt-key del \"\$(sudo apt-key list | grep -B1 'Ceph' | head -n1 | awk '{print \$2}' | cut -d'/' -f2)\" || true
        sudo apt-get update
    "
}

function main() {
    if [ $# -ne 1 ]; then
        echo "usage: $0 [bootstrap-node] (c1/c2/c4)"
        exit 1
    fi

    local bootstrap_node=$1

    echo "===== cleaning ====="

    for node in "${!NODE_IPS[@]}"; do
        cleanup_ceph_services "$node"
        remove_ceph_data "$node"
        cleanup_osd_device "$node"
        uninstall_packages "$node"
    done

    echo "=== clean bootstrap node $bootstrap_node ==="
    ssh -p "${SSH_PORTS[$bootstrap_node]}" "${CEPH_USER}@${NODE_IPS[$bootstrap_node]}" "
        sudo rm -f /root/.ssh/authorized_keys
        sudo rm -f /home/${CEPH_USER}/.ssh/ceph-deploy*
    "

    echo "===== finish ====="
    echo "all nodes data cleaned"
    echo "OSD device $OSD_DEVICE cleaned"
}

main "$@"