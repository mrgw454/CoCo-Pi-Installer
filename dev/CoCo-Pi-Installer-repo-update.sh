#!/usr/bin/env bash
set -euo pipefail

echo "=== Updating CoCo-Pi Installer Repo ==="

# ------------------------------------------------------------
# Canonical repo location
# ------------------------------------------------------------
EXPECTED_ROOT="$HOME/source-CoCo-Pi/CoCo-Pi-Installer"
REPO_ROOT="$(pwd)"

echo "Repo root: $REPO_ROOT"
echo "Expected:  $EXPECTED_ROOT"

if [[ "$REPO_ROOT" != "$EXPECTED_ROOT" ]]; then
    echo "[ERROR] This script must be run from:"
    echo "        $EXPECTED_ROOT"
    exit 1
fi

# ------------------------------------------------------------
# Generate tarballs directly into the repo directory
# ------------------------------------------------------------
echo ""
echo "--- Generating tarballs ---"

cd "$HOME"

run_tar() {
    local label="$1"; shift
    if tar czf "$REPO_ROOT/$label" "$@" 2>/dev/null; then
        echo "  [OK] $label"
    else
        echo "  [WARN] $label (some sources missing — tarball may be incomplete)"
    fi
}

run_tar Desktop.tar.gz          Desktop
run_tar Pictures.tar.gz         Pictures
run_tar scripts.tar.gz          scripts
run_tar fonts.tar.gz            .fonts
run_tar misc-home-files.tar.gz  .vim .wgetrc .irssi \
                                .config/geany/geany.conf .config/geany/filedefs
run_tar mame-menus.tar.gz       .mame
run_tar xroar-menus.tar.gz      .xroar
run_tar trs80gp-menus.tar.gz    .trs80gp
run_tar pyDriveWire-files.tar.gz \
                                pyDriveWire/config/pydrivewirerc-daemon \
                                pyDriveWire/*.sh
run_tar DriveWire-files.tar.gz  DriveWire4/*.sh DriveWire4/config.xml
run_tar lwwire-files.tar.gz     lwwire/*.sh lwwire/serserv lwwire/tcpserv
run_tar tcpser-files.tar.gz     tcpser/*.sh
run_tar media-share1.tar.gz     /media/share1/carts /media/share1/source \
                                /media/share1/software /media/share1/samples
run_tar misc-system-files.tar.gz /etc/samba/smb.conf

# source.tar.gz uses explicit file list — skip silently if optional files absent
echo -n "  source.tar.gz ... "
_src_args=()
[[ -f source/new_windows.zip ]] && _src_args+=(source/new_windows.zip)
for f in source/*.sh; do [[ -f "$f" ]] && _src_args+=("$f"); done
[[ -f source/useroptions.mak ]] && _src_args+=(source/useroptions.mak)
if [[ ${#_src_args[@]} -gt 0 ]]; then
    tar czf "$REPO_ROOT/source.tar.gz" "${_src_args[@]}" 2>/dev/null \
        && echo "[OK]" || echo "[WARN]"
else
    echo "[SKIP] (no source files found)"
fi

# OVCC — glob may produce no matches on non-OVCC machines
echo -n "  ovcc-menus.tar.gz ... "
_ovcc_args=()
for pattern in ".ovcc/*.rom" ".ovcc/*.sh" ".ovcc/*.ini" ".ovcc/ini/*"; do
    for f in $pattern; do [[ -e "$f" ]] && _ovcc_args+=("$f"); done
done
if [[ ${#_ovcc_args[@]} -gt 0 ]]; then
    tar czf "$REPO_ROOT/ovcc-menus.tar.gz" "${_ovcc_args[@]}" 2>/dev/null \
        && echo "[OK]" || echo "[WARN]"
else
    echo "[SKIP] (no OVCC files found)"
fi

# ------------------------------------------------------------
# Capture .bashrc CoCo-Pi section
# ------------------------------------------------------------
echo ""
echo "--- Capturing .bashrc modifications ---"
if grep -q 'modifications' "$HOME/.bashrc" 2>/dev/null; then
    grep -A500 -m1 -e 'modifications' "$HOME/.bashrc" > "$REPO_ROOT/bashrc-cocopi.txt"
    echo "  [OK] bashrc-cocopi.txt"
else
    echo "  [SKIP] bashrc-cocopi.txt (no modifications marker in .bashrc)"
fi

# ------------------------------------------------------------
# cocopi-release.txt (edited manually in repo — copy from home if present)
# ------------------------------------------------------------
if [[ -f "$HOME/cocopi-release.txt" ]]; then
    cp "$HOME/cocopi-release.txt" "$REPO_ROOT/"
    echo "  [OK] cocopi-release.txt"
fi

echo ""
echo "=== Installer repo update complete. Review changes and commit. ==="
