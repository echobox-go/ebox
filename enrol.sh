#!/usr/bin/env bash
# One-line setup for an existing Arch or CachyOS machine:
#
#   curl -fsSL https://portal.example.org/enrol.sh | sudo bash
#
# The portal serves this file with EBOX_REPO_URL, EBOX_REPO_KEY and
# EBOX_PORTAL_URL filled in. It adds the echobox pacman repo, installs ebox and
# starts enrolment. Nothing secret is in this script.

set -euo pipefail

EBOX_REPO_URL="${EBOX_REPO_URL:-@EBOX_REPO_URL@}"
EBOX_REPO_KEY="${EBOX_REPO_KEY:-@EBOX_REPO_KEY@}"       # full fingerprint of the repo signing key
EBOX_PORTAL_URL="${EBOX_PORTAL_URL:-@EBOX_PORTAL_URL@}"

die() { printf 'error: %s\n' "$*" >&2; exit 1; }

[[ $EUID -eq 0 ]] || die "run with sudo"
[[ -f /etc/arch-release ]] || die "this setup is for Arch-based systems"
for v in EBOX_REPO_URL EBOX_REPO_KEY EBOX_PORTAL_URL; do
    [[ "${!v}" != @*@ ]] || die "$v is not set; download this script from your portal"
done
[[ "$EBOX_REPO_KEY" =~ ^[0-9A-F]{40}$ ]] || die "EBOX_REPO_KEY must be a 40-character fingerprint"

echo "> trusting echobox repo key $EBOX_REPO_KEY"
pacman-key --recv-keys "$EBOX_REPO_KEY" --keyserver "hkps://keys.openpgp.org"
pacman-key --lsign-key "$EBOX_REPO_KEY"

if ! grep -q '^\[echobox\]' /etc/pacman.conf; then
    echo "> adding [echobox] to /etc/pacman.conf"
    cp /etc/pacman.conf "/etc/pacman.conf.ebox-backup.$(date +%s)"
    printf '\n[echobox]\nSigLevel = Required DatabaseOptional\nServer = %s\n' "$EBOX_REPO_URL" >> /etc/pacman.conf
fi

pacman -Sy --needed --noconfirm ebox

if ! grep -q '^EBOX_PORTAL_URL=' /etc/ebox/ebox.conf 2>/dev/null; then
    printf 'EBOX_PORTAL_URL=%q\n' "$EBOX_PORTAL_URL" >> /etc/ebox/ebox.conf
else
    sed -i "s|^EBOX_PORTAL_URL=.*|EBOX_PORTAL_URL=$EBOX_PORTAL_URL|" /etc/ebox/ebox.conf
fi
user="${SUDO_USER:-}"
[[ -n "$user" ]] && sed -i "s|^EBOX_USER=.*|EBOX_USER=$user|" /etc/ebox/ebox.conf

echo "> installed. Next: review /etc/ebox/ebox.conf, then"
echo "    sudo ebox enrol"
echo "    sudo ebox push"
