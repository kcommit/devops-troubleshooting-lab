#!/usr/bin/env bash
# ==========================================================
# NFS Server Auto Setup Script with Auto Network Detection
# Supports: Ubuntu/Debian and RHEL/AlmaLinux/Rocky/Fedora
#
# Purpose:
#   Detect OS type, install NFS server packages, create NFS
#   share directory, configure /etc/exports, start NFS service,
#   reload exports, and show client mount command.
#
# Usage:
#   chmod +x nfs-server-setup-auto-network.sh
#   sudo ./nfs-server-setup-auto-network.sh
#
# Optional:
#   sudo ./nfs-server-setup-auto-network.sh /nfs/share auto
#   sudo ./nfs-server-setup-auto-network.sh /nfs/share "*"
#   sudo ./nfs-server-setup-auto-network.sh /nfs/share "172.27.96.0/20"
#
# Arguments:
#   $1 = Share directory, default: /nfs/share
#   $2 = Allowed client/network, default: auto
#
# What "auto" does:
#   It detects the server's main IPv4 CIDR from the default route
#   interface and calculates the network address.
#
# Example:
#   Server IP: 172.27.100.62/20
#   Auto network becomes: 172.27.96.0/20
#
# WARNING:
#   WSL IP can change after restart. Re-run this script if the IP changes.
# ==========================================================

set -euo pipefail

SHARE_DIR="${1:-/nfs/share}"
ALLOWED_CLIENT_INPUT="${2:-auto}"
EXPORT_OPTIONS="rw,sync,no_subtree_check"

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

require_root() {
    if [[ "${EUID}" -ne 0 ]]; then
        error "Please run this script with sudo or as root."
        echo "Example:"
        echo "  sudo ./nfs-server-setup-auto-network.sh"
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
        NFS_PACKAGE="nfs-kernel-server"
        NFS_SERVICE="nfs-kernel-server"
        CLIENT_PACKAGE_DEBIAN="nfs-common"
    elif [[ "${OS_ID}" == "rhel" || "${OS_ID}" == "centos" || "${OS_ID}" == "almalinux" || "${OS_ID}" == "rocky" || "${OS_ID}" == "fedora" || "${OS_LIKE}" == *"rhel"* || "${OS_LIKE}" == *"fedora"* ]]; then
        OS_FAMILY="rhel"
        PKG_INSTALL="dnf"
        NFS_PACKAGE="nfs-utils"
        NFS_SERVICE="nfs-server"
    else
        error "Unsupported OS: ${OS_NAME}"
        echo "Supported examples:"
        echo "  Ubuntu, Debian, RHEL, AlmaLinux, Rocky Linux, Fedora"
        exit 1
    fi

    success "OS family detected: ${OS_FAMILY}"
}

get_default_interface() {
    DEFAULT_IFACE="$(ip route show default 2>/dev/null | awk '{print $5; exit}')"

    if [[ -z "${DEFAULT_IFACE}" ]]; then
        DEFAULT_IFACE="eth0"
        warn "Could not detect default interface. Falling back to eth0."
    fi

    info "Default network interface: ${DEFAULT_IFACE}"
}

get_server_cidr() {
    get_default_interface

    SERVER_CIDR="$(ip -4 -o addr show "${DEFAULT_IFACE}" | awk '{print $4; exit}')"

    if [[ -z "${SERVER_CIDR}" ]]; then
        error "Could not detect server IPv4 CIDR from interface ${DEFAULT_IFACE}."
        echo "Check manually:"
        echo "  ip -4 addr show"
        exit 1
    fi

    SERVER_IP="${SERVER_CIDR%/*}"
    PREFIX="${SERVER_CIDR#*/}"

    success "Detected server CIDR: ${SERVER_CIDR}"
    success "Detected server IP: ${SERVER_IP}"
}

cidr_to_netmask_int() {
    local prefix="$1"
    local mask=$(( 0xffffffff << (32 - prefix) & 0xffffffff ))
    echo "${mask}"
}

ip_to_int() {
    local ip="$1"
    local a b c d
    IFS=. read -r a b c d <<< "${ip}"
    echo $(( (a << 24) + (b << 16) + (c << 8) + d ))
}

int_to_ip() {
    local int="$1"
    echo "$(( (int >> 24) & 255 )).$(( (int >> 16) & 255 )).$(( (int >> 8) & 255 )).$(( int & 255 ))"
}

calculate_network_from_cidr() {
    get_server_cidr

    local ip_int mask_int network_int
    ip_int="$(ip_to_int "${SERVER_IP}")"
    mask_int="$(cidr_to_netmask_int "${PREFIX}")"
    network_int=$(( ip_int & mask_int ))

    AUTO_NETWORK="$(int_to_ip "${network_int}")/${PREFIX}"

    success "Auto-detected allowed NFS network: ${AUTO_NETWORK}"
}

resolve_allowed_client() {
    if [[ "${ALLOWED_CLIENT_INPUT}" == "auto" ]]; then
        calculate_network_from_cidr
        ALLOWED_CLIENT="${AUTO_NETWORK}"
    else
        get_server_cidr
        ALLOWED_CLIENT="${ALLOWED_CLIENT_INPUT}"
    fi

    if [[ "${ALLOWED_CLIENT}" == "*" ]]; then
        warn "Allowed client is '*'. This allows all clients that can reach the server."
        warn "Good for practice labs, not recommended for production."
    else
        success "Allowed client/network: ${ALLOWED_CLIENT}"
    fi
}

install_nfs() {
    info "Installing NFS package: ${NFS_PACKAGE}"

    if [[ "${PKG_INSTALL}" == "apt" ]]; then
        apt update
        apt install -y "${NFS_PACKAGE}"
    elif [[ "${PKG_INSTALL}" == "dnf" ]]; then
        dnf install -y "${NFS_PACKAGE}"
    fi

    success "NFS package installed."
}

create_share_dir() {
    info "Creating NFS share directory: ${SHARE_DIR}"

    mkdir -p "${SHARE_DIR}"

    # Practice-lab permission.
    # For production, use proper ownership and group permissions.
    chmod 777 "${SHARE_DIR}"

    success "Share directory created and permission set to 777 for lab practice."
    warn "chmod 777 is for practice only. Do not use open permissions in production."
}

backup_exports() {
    if [[ -f /etc/exports ]]; then
        BACKUP_FILE="/etc/exports.backup.$(date +%Y%m%d-%H%M%S)"
        cp /etc/exports "${BACKUP_FILE}"
        success "Backup created: ${BACKUP_FILE}"
    else
        touch /etc/exports
        success "Created new /etc/exports file."
    fi
}

configure_exports() {
    EXPORT_LINE="${SHARE_DIR} ${ALLOWED_CLIENT}(${EXPORT_OPTIONS})"

    info "Configuring /etc/exports"
    info "Export line: ${EXPORT_LINE}"

    # Remove old entry for the same share directory to avoid duplicates.
    sed -i "\|^${SHARE_DIR}[[:space:]]|d" /etc/exports

    echo "${EXPORT_LINE}" >> /etc/exports

    success "/etc/exports updated."
}

start_nfs_service() {
    info "Starting and enabling NFS service: ${NFS_SERVICE}"

    systemctl enable --now "${NFS_SERVICE}" || {
        warn "Could not enable/start ${NFS_SERVICE}. Trying service restart only..."
        systemctl restart "${NFS_SERVICE}"
    }

    success "NFS service is running or restart command completed."
}

reload_exports() {
    info "Reloading NFS exports"

    exportfs -rav

    success "NFS exports reloaded."

    info "Current NFS exports:"
    exportfs -v
}

configure_firewall_if_available() {
    if command -v firewall-cmd >/dev/null 2>&1; then
        info "firewalld detected. Adding NFS services."

        firewall-cmd --permanent --add-service=nfs || true
        firewall-cmd --permanent --add-service=mountd || true
        firewall-cmd --permanent --add-service=rpc-bind || true
        firewall-cmd --reload || true

        success "firewalld rules attempted."
    elif command -v ufw >/dev/null 2>&1; then
        info "ufw detected."

        if [[ "${ALLOWED_CLIENT}" == "*" ]]; then
            warn "ALLOWED_CLIENT is '*'. Allowing NFS from anywhere is not recommended."
            ufw allow nfs || true
        else
            ufw allow from "${ALLOWED_CLIENT}" to any port nfs || true
        fi

        success "ufw rule attempted."
    else
        warn "No supported firewall tool found or firewall not installed. Skipping firewall configuration."
    fi
}

show_summary() {
    echo
    echo "=========================================================="
    echo " NFS SERVER SETUP COMPLETED"
    echo "=========================================================="
    echo "OS                 : ${OS_NAME}"
    echo "Interface          : ${DEFAULT_IFACE}"
    echo "Server CIDR        : ${SERVER_CIDR}"
    echo "Server IP          : ${SERVER_IP}"
    echo "Share Directory    : ${SHARE_DIR}"
    echo "Allowed Client     : ${ALLOWED_CLIENT}"
    echo "Export Options     : ${EXPORT_OPTIONS}"
    echo "NFS Service        : ${NFS_SERVICE}"
    echo "=========================================================="
    echo
    echo "Check exports on server:"
    echo "  sudo exportfs -v"
    echo "  showmount -e localhost"
    echo
    echo "Client-side install commands:"
    echo
    echo "Ubuntu/Debian client:"
    echo "  sudo apt install nfs-common -y"
    echo
    echo "RHEL/Alma/Rocky/Fedora client:"
    echo "  sudo dnf install nfs-utils -y"
    echo
    echo "Client-side test commands:"
    echo "  sudo ping -c 4 ${SERVER_IP}"
    echo "  showmount -e ${SERVER_IP}"
    echo
    echo "Client-side mount commands:"
    echo "  sudo mkdir -p /mnt/nfs-share"
    echo "  sudo mount -t nfs ${SERVER_IP}:${SHARE_DIR} /mnt/nfs-share"
    echo "  df -h | grep nfs"
    echo "  mount | grep nfs"
    echo
    echo "Test from client:"
    echo "  echo \"Hello from NFS client\" | sudo tee /mnt/nfs-share/test.txt"
    echo
    echo "Verify on server:"
    echo "  ls -l ${SHARE_DIR}"
    echo "  cat ${SHARE_DIR}/test.txt"
    echo
    echo "Unmount on client:"
    echo "  sudo umount /mnt/nfs-share"
    echo
    echo "WSL reminder:"
    echo "  WSL IP can change after restart."
    echo "  Re-run this script or run 'ip -4 addr show eth0' if connection fails later."
    echo "=========================================================="
}

main() {
    require_root
    detect_os
    resolve_allowed_client

    warn "This script will configure this machine as an NFS SERVER."
    warn "Share directory: ${SHARE_DIR}"
    warn "Allowed client/network: ${ALLOWED_CLIENT}"
    echo

    install_nfs
    create_share_dir
    backup_exports
    configure_exports
    start_nfs_service
    reload_exports
    configure_firewall_if_available
    show_summary

    success "NFS server setup completed successfully."
}

main "$@"
