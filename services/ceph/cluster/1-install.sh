#!/bin/bash

# Usage: ./deploy_ceph.sh [bootstrap-node-hostname]

set -euo pipefail

CEPH_USER="auden"
CEPH_VERSION="reef"  # reef,quincy
MON_NODES=("c1" "c2" "c4")
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

function check_prerequisites() {
    echo "checking ssh connection"
    for node in "${MON_NODES[@]}"; do
        if ! ssh -p "${SSH_PORTS[$node]}" "${CEPH_USER}@${NODE_IPS[$node]}" "echo 'connected: $node'"; then
            echo "ssh can not connect: $node"
            exit 1
        fi
    done
}

function check_sudo() {
    local node=$1
    local ip=${NODE_IPS[$node]}
    local port=${SSH_PORTS[$node]}

    if ! ssh -p "$port" "${CEPH_USER}@${ip}" "sudo -n true"; then
        echo "[Error] node $node have not sudo privilege"
        echo "Run the command: echo '$CEPH_USER ALL=(ALL) NOPASSWD:ALL' | sudo tee /etc/sudoers.d/$CEPH_USER"
        exit 1
    fi
}

function install_package() {
    echo "install python3 lvm2 chrony curl gpg"
    for node in "${MON_NODES[@]}"; do
        ssh -p "${SSH_PORTS[$node]}" "${CEPH_USER}@${NODE_IPS[$node]}" "sudo apt update && sudo apt install -y python3 lvm2 chrony"
    done
}

function check_disks() {
    for node in "${!NODE_IPS[@]}"; do
        echo "=== check $node $OSD_DEVICE ==="
        if ! ssh -p "${SSH_PORTS[$node]}" "${CEPH_USER}@${NODE_IPS[$node]}" "lsblk -f $OSD_DEVICE"; then
            echo "[Error] node $node have no $OSD_DEVICE"
            exit 1
        fi

        ssh -p "${SSH_PORTS[$node]}" "${CEPH_USER}@${NODE_IPS[$node]}" "sudo wipefs -a $OSD_DEVICE && sudo sgdisk --zap-all $OSD_DEVICE"
    done
}

function bootstrap_cluster() {
    local bootstrap_node=$1
    local mon_ip="${NODE_IPS[$bootstrap_node]}"
    local ssh_port="${SSH_PORTS[$bootstrap_node]}"

    echo "=== $bootstrap_node (IP: $mon_ip) bootstrap cluster ==="
    
    ssh -p "$ssh_port" "${CEPH_USER}@${mon_ip}" "sudo rm -rf /etc/ceph/* /var/lib/ceph/*"

    ssh -p "$ssh_port" "${CEPH_USER}@${mon_ip}" \
        "sudo rm /etc/apt/sources.list.d/ceph.list \
        sudo apt-add-repository -y "deb https://download.ceph.com/debian-${CEPH_VERSION}/ $(lsb_release -sc) main"
        sudo apt update && sudo apt install -y cephadm"

    if [ ! -f "$HOME/.ssh/ceph-deploy" ]; then
        ssh-keygen -t ed25519 -N "" -f "$HOME/.ssh/ceph-deploy"
    fi

    for node in "${MON_NODES[@]}"; do
        ssh-copy-id -i "$HOME/.ssh/ceph-deploy.pub" -p "${SSH_PORTS[$node]}" "${CEPH_USER}@${NODE_IPS[$node]}"
    done

    ssh -p "$ssh_port" "${CEPH_USER}@${mon_ip}" \
        "sudo cephadm bootstrap \
        --mon-ip $mon_ip \
        --ssh-user ${CEPH_USER} \
        --ssh-private-key /home/${CEPH_USER}/.ssh/ceph-deploy \
        --ssh-public-key /home/${CEPH_USER}/.ssh/ceph-deploy.pub \
        --allow-fqdn-hostname \
        --skip-mon-network \
        --skip-dashboard \
        --cluster-network 192.168.1.0/24 \
        --skip-monitoring-stack"
}

function add_cluster_nodes() {
    local bootstrap_node=$1
    local ssh_port="${SSH_PORTS[$bootstrap_node]}"

    echo "add other node"
    for node in "${MON_NODES[@]}"; do
        if [ "$node" != "$bootstrap_node" ]; then
            echo "adding $node..."
            ssh -p "$ssh_port" "${CEPH_USER}@${NODE_IPS[$bootstrap_node]}" "sudo ceph orch host add $node ${NODE_IPS[$node]}"
        fi
    done

    ssh -p "$ssh_port" "${CEPH_USER}@${NODE_IPS[$bootstrap_node]}" "sudo ceph orch host ls"
}

function deploy_mons() {
    local bootstrap_node=$1
    local ssh_port="${SSH_PORTS[$bootstrap_node]}"

    echo "=== deploy mons ==="
    for node in "${MON_NODES[@]}"; do
        if [ "$node" != "$bootstrap_node" ]; then
            echo "adding $node..."
            ssh -p "$ssh_port" "${CEPH_USER}@${NODE_IPS[$bootstrap_node]}" "sudo ceph orch daemon add mon $node:${NODE_IPS[$node]}"
        fi
    done

    # sleep 10
    echo "=== OSD Status ==="
    ssh -p "$ssh_port" "${CEPH_USER}@${NODE_IPS[$bootstrap_node]}" "sudo ceph mon stat"
}

function deploy_osds() {
    local bootstrap_node=$1
    local ssh_port="${SSH_PORTS[$bootstrap_node]}"

    echo "=== deploy $OSD_DEVICE as OSD ==="
    for node in "${!NODE_IPS[@]}"; do
        echo "node $node create OSD..."
        ssh -p "$ssh_port" "${CEPH_USER}@${NODE_IPS[$bootstrap_node]}" "sudo ceph orch daemon add osd $node:$OSD_DEVICE"
    done

    sleep 10
    echo "=== OSD Status ==="
    ssh -p "$ssh_port" "${CEPH_USER}@${NODE_IPS[$bootstrap_node]}" "sudo ceph osd tree"
}

function create_pools() {
    local bootstrap_node=$1
    local ssh_port="${SSH_PORTS[$bootstrap_node]}"

    echo "=== create pool ==="
    ssh -p "$ssh_port" "${CEPH_USER}@${NODE_IPS[$bootstrap_node]}" "sudo ceph osd pool create replicapool"

    sleep 10
    echo "=== pool Status ==="
    ssh -p "$ssh_port" "${CEPH_USER}@${NODE_IPS[$bootstrap_node]}" "sudo ceph osd pool ls"
}

function create_filesystem() {
    local bootstrap_node=$1
    local ssh_port="${SSH_PORTS[$bootstrap_node]}"

    echo "=== create pool for filesystem meta data ==="
    ssh -p "$ssh_port" "${CEPH_USER}@${NODE_IPS[$bootstrap_node]}" "sudo ceph osd pool create myfs_metadata"

    echo "=== create pool for filesystem data ==="
    ssh -p "$ssh_port" "${CEPH_USER}@${NODE_IPS[$bootstrap_node]}" "sudo ceph osd pool create myfs_data"

    echo "=== create filesystem ==="
    ssh -p "$ssh_port" "${CEPH_USER}@${NODE_IPS[$bootstrap_node]}" "sudo ceph fs new myfs myfs_metadata myfs_data"

    echo "=== enable mds for filesystem ==="
    ssh -p "$ssh_port" "${CEPH_USER}@${NODE_IPS[$bootstrap_node]}" "sudo ceph orch apply mds myfs 1"

    sleep 10
    echo "=== pool Status ==="
    ssh -p "$ssh_port" "${CEPH_USER}@${NODE_IPS[$bootstrap_node]}" "sudo ceph fs ls"
}

function create_rgw() {
    local bootstrap_node=$1
    local ssh_port="${SSH_PORTS[$bootstrap_node]}"

    echo "=== create realm ==="
    ssh -p "$ssh_port" "${CEPH_USER}@${NODE_IPS[$bootstrap_node]}" "sudo radosgw-admin realm create --rgw-realm=america"

    echo "=== create zone group ==="
    ssh -p "$ssh_port" "${CEPH_USER}@${NODE_IPS[$bootstrap_node]}" "sudo radosgw-admin zonegroup create --rgw-realm=america --rgw-zonegroup=us-east --endpoints=https://us-east-s3.$DOMAIN:443 --master --default"

    echo "=== create zone ==="
    ssh -p "$ssh_port" "${CEPH_USER}@${NODE_IPS[$bootstrap_node]}" "sudo radosgw-admin zone create --rgw-zonegroup=us-east --rgw-zone=us-east-a --master --default"

    echo "=== create system user ==="
    ssh -p "$ssh_port" "${CEPH_USER}@${NODE_IPS[$bootstrap_node]}" "sudo radosgw-admin user create --uid="admin" --display-name="Administrator User" --system"

    echo "=== add user to master zone and commit period, access-key and secret from the output after create user command ==="
    ssh -p "$ssh_port" "${CEPH_USER}@${NODE_IPS[$bootstrap_node]}" "sudo radosgw-admin zone modify --rgw-zone=us-east-a --access-key=EHYDO0ZAKA71YRRU8D29 --secret=PztTjcbAPiGskL3KFqDiRZ3A1G7vc9sMPggivrxw"

    echo "=== update period ==="
    ssh -p "$ssh_port" "${CEPH_USER}@${NODE_IPS[$bootstrap_node]}" "sudo radosgw-admin period update --commit"

    echo "=== update zone group config ==="
    ssh -p "$ssh_port" "${CEPH_USER}@${NODE_IPS[$bootstrap_node]}" "sudo radosgw-admin zonegroup get --rgw-zonegroup=us-east > zonegroup.json"
    ### update zonegroup.json file with your needs
    ssh -p "$ssh_port" "${CEPH_USER}@${NODE_IPS[$bootstrap_node]}" "sudo radosgw-admin zonegroup set --rgw-zonegroup=us-east --infile=zonegroup.json"
    ssh -p "$ssh_port" "${CEPH_USER}@${NODE_IPS[$bootstrap_node]}" "sudo radosgw-admin period update --commit"

    echo "=== update zone config ==="
    ssh -p "$ssh_port" "${CEPH_USER}@${NODE_IPS[$bootstrap_node]}" "sudo radosgw-admin zone get --rgw-zone=us-east-a > zone.json"
    ### update zone.json file with your needs
    ssh -p "$ssh_port" "${CEPH_USER}@${NODE_IPS[$bootstrap_node]}" "sudo radosgw-admin zone set --rgw-zone=us-east-a --infile=zone.json"
    ssh -p "$ssh_port" "${CEPH_USER}@${NODE_IPS[$bootstrap_node]}" "sudo radosgw-admin period update --commit"

    echo "=== enable rgw service ==="
    ssh -p "$ssh_port" "${CEPH_USER}@${NODE_IPS[$bootstrap_node]}" "sudo ceph orch apply rgw america --placement="c1,c2,c4" --port=7480"

    echo "=== check rgw service ==="
    ssh -p "$ssh_port" "${CEPH_USER}@${NODE_IPS[$bootstrap_node]}" "sudo ceph orch ps | grep rgw"

    echo "=== restart rgw service if need ==="
    ssh -p "$ssh_port" "${CEPH_USER}@${NODE_IPS[$bootstrap_node]}" "sudo ceph orch restart rgw.america"

    # echo "=== add rgw instance if need ==="
    # ssh -p "$ssh_port" "${CEPH_USER}@${NODE_IPS[$bootstrap_node]}" "sudo ceph orch apply rgw america --placement="c1,c2,c4,c5,c6""

    # echo "=== remove rgw service if need ==="
    # ssh -p "$ssh_port" "${CEPH_USER}@${NODE_IPS[$bootstrap_node]}" "sudo ceph orch rm rgw.america"
}

function main() {
    if [ $# -ne 1 ]; then
        echo "usage: $0 [bootstrap-node-name] (options: c1/c2/c4)"
        exit 1
    fi

    local bootstrap_node=$1

    check_prerequisites
    
    for node in "${!NODE_IPS[@]}"; do
        check_sudo "$node"
    done

    install_package

    check_disks
    bootstrap_cluster "$bootstrap_node"
    add_cluster_nodes "$bootstrap_node"
    deploy_mons "$bootstrap_node"
    deploy_osds "$bootstrap_node"

    create_pools "$bootstrap_node"
    create_filesystem "$bootstrap_node"



    echo "=== finished ==="
    echo "Cluster status: ssh -p ${SSH_PORTS[$bootstrap_node]} ${CEPH_USER}@${NODE_IPS[$bootstrap_node]} 'sudo ceph -s'"
}

main "$@"