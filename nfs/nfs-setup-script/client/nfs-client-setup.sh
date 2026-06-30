#!/usr/bin/env bash
# ==========================================================
# NFS Client Auto Setup Script
# Supports: Ubuntu/Debian and RHEL/AlmaLinux/Rocky/Fedora
#
# Purpose:
#   Detect OS type, install NFS client packages, create mount
#   point, check server export, mount NFS share, verify mount,
#   and optionally add entry to /etc/fstab.
#
# Usage:
#   chmod +x nfs-client-setup.sh
#   sudo ./nfs-client-setup.sh SERVER_IP
#
# Optional:
#   sudo ./nfs-client-setup.sh SERVER_IP /nfs/share /mnt/nfs-share
#   sudo ./nfs-client-setup.sh SERVER_IP /nfs/share /mnt/nfs-share --fstab
#
# Arguments:
#   $1 = NFS server IP or hostname, required
#   $2 = Remote share path, default: /nfs/share
#   $3 = Local mount point, default: /mnt/nfs-share
#   $4 = Optional: --fstab to make mount permanent
#
# Examples:
#   sudo ./nfs-client-setup.sh 172.27.100.62
#   sudo ./nfs-client-setup.sh 172.27.100.62 /nfs/share /mnt/nfs-share
#   sudo ./nfs-client-setup.sh 172.27.100.62 /nfs/share /mnt/nfs-share --fstab
#
# WSL Note:
#   In some WSL distros, ping may need sudo.
#   WSL server IP can change after restart.
# ==========================================================

set -euo pipefail

SERVER_IP="${1:-}"
REMOTE_SHARE="${2:-/nfs/share}"
MOUNT_POINT="${3:-/mnt/nfs-share}"
FSTAB_FLAG="${4:-}"

GREEN="\033[0;32m"
YELLOW="\033[1;33m"
RED="\033[0;31m"
BLUE="\033[0;34m"
NC="\033[0m"

info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

warn() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

usage() {
    echo "Usage:"
    echo "  sudo ./nfs-client-setup.sh SERVER_IP"
    echo
    echo "Optional:"
    echo "  sudo ./nfs-client-setup.sh SERVER_IP /nfs/share /mnt/nfs-share"
    echo "  sudo ./nfs-client-setup.sh SERVER_IP /nfs/share /mnt/nfs-share --fstab"
    echo
    echo "Examples:"
    echo "  sudo ./nfs-client-setup.sh 172.27.100.62"
    echo "  sudo ./nfs-client-setup.sh 172.27.100.62 /nfs/share /mnt/nfs-share"
    echo "  sudo ./nfs-client-setup.sh 172.27.100.62 /nfs/share /mnt/nfs-share --fstab"
}

require_root() {
    if [[ "${EUID}" -ne 0 ]]; then
        error "Please run this script with sudo or as root."
        usage
        exit 1
    fi
}

validate_args() {
    if [[ -z "${SERVER_IP}" ]]; then
        error "NFS server IP/hostname is required."
        usage
        exit 1
    fi

    if [[ "${FSTAB_FLAG}" != "" && "${FSTAB_FLAG}" != "--fstab" ]]; then
        error "Invalid fourth argument: ${FSTAB_FLAG}"
        echo "Only supported optional fourth argument is: --fstab"
        exit 1
    fi
}

detect_os() {
    if [[ ! -f /etc/os-release ]]; then
        error "/etc/os-release not found. Cannot detect OS."
        exit 1
    fi

    # shellcheck disable=SC1091
    source /etc/os-release

    OS_ID="${ID:-unknown}"
    OS_LIKE="${ID_LIKE:-}"
    OS_NAME="${PRETTY_NAME:-unknown}"

    info "Detected OS: ${OS_NAME}"

    if [[ "${OS_ID}" == "ubuntu" || "${OS_ID}" == "debian" || "${OS_LIKE}" == *"debian"* ]]; then
        OS_FAMILY="debian"
        PKG_INSTALL="apt"
        NFS_CLIENT_PACKAGE="nfs-common"
    elif [[ "${OS_ID}" == "rhel" || "${OS_ID}" == "centos" || "${OS_ID}" == "almalinux" || "${OS_ID}" == "rocky" || "${OS_ID}" == "fedora" || "${OS_LIKE}" == *"rhel"* || "${OS_LIKE}" == *"fedora"* ]]; then
        OS_FAMILY="rhel"
        PKG_INSTALL="dnf"
        NFS_CLIENT_PACKAGE="nfs-utils"
    else
        error "Unsupported OS: ${OS_NAME}"
        echo "Supported examples:"
        echo "  Ubuntu, Debian, RHEL, AlmaLinux, Rocky Linux, Fedora"
        exit 1
    fi

    success "OS family detected: ${OS_FAMILY}"
}

install_nfs_client() {
    info "Installing NFS client package: ${NFS_CLIENT_PACKAGE}"

    if [[ "${PKG_INSTALL}" == "apt" ]]; then
        apt update
        apt install -y "${NFS_CLIENT_PACKAGE}"
    elif [[ "${PKG_INSTALL}" == "dnf" ]]; then
        dnf install -y "${NFS_CLIENT_PACKAGE}"
    fi

    success "NFS client package installed."
}

check_network() {
    info "Checking network connectivity to NFS server: ${SERVER_IP}"

    if ping -c 2 -W 2 "${SERVER_IP}" >/dev/null 2>&1; then
        success "Ping to ${SERVER_IP} successful."
    else
        warn "Ping failed or is blocked. This does not always mean NFS will fail."
        warn "In WSL, ping may require sudo or may be restricted."
        warn "Continuing to check NFS export..."
    fi
}

check_showmount() {
    info "Checking NFS exports from server: ${SERVER_IP}"

    if showmount -e "${SERVER_IP}"; then
        success "showmount command succeeded."
    else
        warn "showmount failed."
        warn "Possible causes:"
        echo "  - NFS server is not running"
        echo "  - /etc/exports is not configured"
        echo "  - Firewall/Security Group is blocking NFS/rpcbind"
        echo "  - Server IP changed"
        echo "  - NFSv4-only setup may not show via showmount in some environments"
        echo
        warn "Continuing to try direct mount..."
    fi
}

create_mount_point() {
    info "Creating local mount point: ${MOUNT_POINT}"

    mkdir -p "${MOUNT_POINT}"

    success "Mount point ready: ${MOUNT_POINT}"
}

is_already_mounted() {
    mountpoint -q "${MOUNT_POINT}"
}

mount_nfs_share() {
    local remote="${SERVER_IP}:${REMOTE_SHARE}"

    if is_already_mounted; then
        warn "${MOUNT_POINT} is already mounted."
        mount | grep "${MOUNT_POINT}" || true
        return
    fi

    info "Mounting NFS share:"
    info "Remote: ${remote}"
    info "Local : ${MOUNT_POINT}"

    mount -t nfs "${remote}" "${MOUNT_POINT}"

    success "NFS share mounted successfully."
}

verify_mount() {
    info "Verifying NFS mount"

    if mountpoint -q "${MOUNT_POINT}"; then
        success "${MOUNT_POINT} is a mount point."
        echo
        df -h | grep -E "nfs|${MOUNT_POINT}" || true
        echo
        mount | grep "${MOUNT_POINT}" || true
    else
        error "${MOUNT_POINT} is not mounted."
        exit 1
    fi
}

test_write() {
    local test_file="${MOUNT_POINT}/nfs-client-test-$(date +%Y%m%d-%H%M%S).txt"

    info "Testing write access with file: ${test_file}"

    if echo "Hello from NFS client: $(hostname) at $(date)" > "${test_file}" 2>/dev/null; then
        success "Write test successful."
        ls -l "${test_file}"
    else
        warn "Normal write failed. Trying with sudo tee..."
        if echo "Hello from NFS client: $(hostname) at $(date)" | tee "${test_file}" >/dev/null; then
            success "Write test successful using root."
            ls -l "${test_file}"
            warn "If owner appears as nobody on server, that is usually because of root_squash."
        else
            warn "Write test failed."
            warn "Possible causes:"
            echo "  - Server directory permissions"
            echo "  - NFS export options"
            echo "  - root_squash behavior"
            echo "  - Read-only export"
        fi
    fi
}

backup_fstab() {
    local backup_file="/etc/fstab.backup.$(date +%Y%m%d-%H%M%S)"
    cp /etc/fstab "${backup_file}"
    success "Backup created: ${backup_file}"
}

add_to_fstab() {
    local remote="${SERVER_IP}:${REMOTE_SHARE}"
    local fstab_line="${remote} ${MOUNT_POINT} nfs defaults,_netdev 0 0"

    if [[ "${FSTAB_FLAG}" != "--fstab" ]]; then
        info "Skipping /etc/fstab because --fstab was not provided."
        return
    fi

    warn "Adding NFS mount to /etc/fstab."
    warn "Be careful in WSL because server IP can change after restart."

    backup_fstab

    # Remove old entry for the same mount point to avoid duplicates.
    sed -i "\|[[:space:]]${MOUNT_POINT}[[:space:]]|d" /etc/fstab

    echo "${fstab_line}" >> /etc/fstab

    success "/etc/fstab updated with:"
    echo "${fstab_line}"

    info "Testing fstab with mount -a"
    mount -a

    success "mount -a completed."
}

show_summary() {
    echo
    echo "=========================================================="
    echo " NFS CLIENT SETUP COMPLETED"
    echo "=========================================================="
    echo "OS              : ${OS_NAME}"
    echo "NFS Server      : ${SERVER_IP}"
    echo "Remote Share    : ${REMOTE_SHARE}"
    echo "Local Mount     : ${MOUNT_POINT}"
    echo "Fstab Enabled   : ${FSTAB_FLAG:-no}"
    echo "=========================================================="
    echo
    echo "Useful commands:"
    echo "  showmount -e ${SERVER_IP}"
    echo "  df -h | grep nfs"
    echo "  mount | grep nfs"
    echo "  ls -l ${MOUNT_POINT}"
    echo
    echo "Create test file:"
    echo "  echo \"Hello from NFS client\" | sudo tee ${MOUNT_POINT}/test.txt"
    echo
    echo "Unmount:"
    echo "  sudo umount ${MOUNT_POINT}"
    echo
    echo "Mount again:"
    echo "  sudo mount -t nfs ${SERVER_IP}:${REMOTE_SHARE} ${MOUNT_POINT}"
    echo
    echo "WSL reminder:"
    echo "  If server WSL restarts, its IP can change."
    echo "  Check server IP again with: ip -4 addr show eth0"
    echo "=========================================================="
}

main() {
    require_root
    validate_args
    detect_os

    warn "This script will configure this machine as an NFS CLIENT."
    warn "Server: ${SERVER_IP}"
    warn "Remote share: ${REMOTE_SHARE}"
    warn "Local mount point: ${MOUNT_POINT}"
    echo

    install_nfs_client
    check_network
    check_showmount
    create_mount_point
    mount_nfs_share
    verify_mount
    test_write
    add_to_fstab
    show_summary

    success "NFS client setup completed successfully."
}

main "$@"
