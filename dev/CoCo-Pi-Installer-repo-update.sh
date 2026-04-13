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

cd "$HOME"

# ------------------------------------------------------------
# Refresh git_info.txt from the launcher repo so rpi500 shows
# the same rev as x570 (which reads the repo live via git log)
# ------------------------------------------------------------
LAUNCHER_REPO="$HOME/source-CoCo-Pi/CoCo-Pi-Launcher"
if [[ -d "$LAUNCHER_REPO/.git" ]]; then
    git -C "$LAUNCHER_REPO" log -1 --format="%h %ad" --date=short \
        > "$HOME/scripts/launcher/git_info.txt"
    echo "  git_info.txt: $(cat "$HOME/scripts/launcher/git_info.txt")"
else
    echo "  [WARN] CoCo-Pi-Launcher repo not found — git_info.txt not updated"
fi

# ------------------------------------------------------------
# Helper
# ------------------------------------------------------------
run_tar() {
    local label="$1"; shift
    if tar czf "$REPO_ROOT/$label" "$@" 2>/dev/null; then
        echo "  [OK] $label"
    else
        echo "  [WARN] $label (some sources missing — tarball may be incomplete)"
    fi
}

# ------------------------------------------------------------
# Generating tarballs
# ------------------------------------------------------------
echo ""
echo "--- Generating tarballs ---"

# Desktop — CoCo/retro-related items only
run_tar Desktop.tar.gz \
    "Desktop/Emulators (Online)/cocobot"* \
    "Desktop/Emulators (Online)/Flex"* \
    "Desktop/Emulators (Online)/Get"* \
    "Desktop/Emulators (Online)/"*Color* \
    "Desktop/Emulators (Online)/"*Dragon* \
    "Desktop/Emulators (Online)/MC-10"* \
    "Desktop/Emulators (Online)/"*Motorola* \
    "Desktop/Emulators (Online)/ugBASIC"* \
    "Desktop/Emulators (Online)/XRoar"* \
    "Desktop/Retro Computer Forums & News/"*worldofdragon* \
    "Desktop/Retro Computer Forums & News/ColorComputer"* \
    "Desktop/Retro Computer Forums & News/MAME"* \
    "Desktop/Retro Computer Forums & News/MC-10"* \
    "Desktop/Retro Computer Forums & News/"*CoCo* \
    "Desktop/Retro Computer Forums & News/"*CoCo-Pi* \
    "Desktop/Retro Computer Forums & News/"*Trash* \
    "Desktop/Retro Computer Forums & News/Vintage"* \
    Desktop/CoCo*

# Pictures — CoCo/retro-related items only
run_tar Pictures.tar.gz \
    Pictures/*CoCo* Pictures/*coco* Pictures/*Coco* Pictures/*rduino* Pictures/BASIC* \
    Pictures/CM* Pictures/DOS* Pictures/dos* Pictures/Dragon* Pictures/dw4* Pictures/flexemu* \
    Pictures/Fuji* Pictures/fuji* Pictures/HxC* Pictures/irata* Pictures/MAME* Pictures/MC-10* \
    Pictures/mc-10* Pictures/Monitor* Pictures/MPI* Pictures/NoICE* Pictures/online6809* Pictures/OVCC* \
    Pictures/PuTTY* Pictures/pyD* Pictures/Realistic* Pictures/Tandy* Pictures/trs80gp* Pictures/VCC* Pictures/XRoar* \
    Pictures/seergdb* Pictures/F256Jr* Pictures/RunCPM*

# scripts — exclude non-CoCo and platform-specific files
echo -n "  scripts.tar.gz ... "
find scripts \( -type f -o -type d \) \
    ! -iname '*.ps1' \
    ! -iname '*altirra*' \
    ! -iname '*apple*' \
    ! -iname '*atari*' \
    ! -iname '*msx*' \
    ! -iname '*99*' \
    ! -iname '*trs80[^g]*' \
    ! -path '*/.claude' \
    ! -path '*/.claude/*' \
    | tar -czf "$REPO_ROOT/scripts.tar.gz" --no-recursion -T - 2>/dev/null \
    && echo "[OK]" || echo "[WARN]"

# source — specific files only
echo -n "  source.tar.gz ... "
tar czf "$REPO_ROOT/source.tar.gz" \
    --exclude='source/pdd.sh' \
    source/new_windows.zip \
    source/*.sh \
    source/useroptions.mak \
    source/ovcc-patch-package-cc936b2.tar.gz \
    source/coco3-jaggies-patches.zip \
    2>/dev/null && echo "[OK]" || echo "[WARN]"

# fonts — CoCo/retro fonts only
run_tar fonts.tar.gz \
    .fonts/HotCoCo*.* .fonts/AnotherMansTreasure*.* .fonts/PixelTandysoft*.* .fonts/*Tandy1K*.*

# misc home files
run_tar misc-home-files.tar.gz \
    .vim .wgetrc .irssi .config/Code/User/tasks.json

# mame — exclude non-CoCo systems and transient dirs
echo -n "  mame.tar.gz ... "
find .mame \( -type f -o -type d \) \
    ! -path '.mame/Nvram' \
    ! -path '.mame/Nvram/*' \
    ! -path '.mame/snap' \
    ! -path '.mame/snap/*' \
    ! -path '.mame/history/*' \
    ! -path '.mame/ui/*' \
    ! -name '.optional_mame_parameters_*.txt' \
    ! -iname '*adam*' \
    ! -iname '*alice*' \
    ! -iname '*apple*' \
    ! -iname '*aquarius*' \
    ! -iname '*atari*' \
    ! -iname '*msx*' \
    ! -iname '*nabu*' \
    ! -iname '*99*' \
    ! -iname '*68000*' \
    ! -iname '*c64*' \
    ! -iname '*c128*' \
    ! -iname '*commodore*' \
    ! -iname '*coleco*' \
    ! -iname 'plugin.ini' \
    ! -iname 'ui.ini' \
    ! -iname '*.backup' \
    -o -path '.mame/cfg/coco*' \
    -o -path '.mame/cfg/dragon*' \
    -o -path '.mame/cfg/mc10*' \
    -o -path '.mame/cfg/cp400*' \
    -o -path '.mame/cfg/agvision*' \
    -o -path '.mame/cfg/trsvidtx*' \
    -o -path '.mame/cfg/d64*' \
    -o -path '.mame/cfg/mcx*' \
    | sort -u \
    | tar -czf "$REPO_ROOT/mame.tar.gz" --no-recursion -T - 2>/dev/null \
    && echo "[OK]" || echo "[WARN]"

run_tar xroar.tar.gz .xroar

# ovcc — specific file types only
echo -n "  ovcc.tar.gz ... "
_ovcc_args=()
for pattern in ".ovcc/*.rom" ".ovcc/*.sh" ".ovcc/*.ini" ".ovcc/ini/*"; do
    for f in $pattern; do [[ -e "$f" ]] && _ovcc_args+=("$f"); done
done
if [[ ${#_ovcc_args[@]} -gt 0 ]]; then
    tar czf "$REPO_ROOT/ovcc.tar.gz" "${_ovcc_args[@]}" 2>/dev/null \
        && echo "[OK]" || echo "[WARN]"
else
    echo "[SKIP] (no OVCC files found)"
fi

run_tar trs80gp.tar.gz .trs80gp

run_tar pyDriveWire-files.tar.gz \
    pyDriveWire/config/pydrivewirerc-daemon pyDriveWire/*.sh \
    pyDriveWire/pyDwCli*.* pyDriveWire/pyDwCli

run_tar DriveWire-files.tar.gz DriveWire4/*.sh DriveWire4/config.xml

run_tar tcpser-files.tar.gz tcpser/start_tcpser.sh tcpser/stop_tcpser.sh

# media-share1 — specific subdirs only, exclude dated backup dirs and .claude
echo -n "  media-share1.tar.gz ... "
if [[ -d /media/share1 ]]; then
    tar czf "$REPO_ROOT/media-share1.tar.gz" \
        --exclude='/media/share1/source/*/[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]_[0-9][0-9].[0-9][0-9].[0-9][0-9]' \
        --exclude='*/.claude' \
        --exclude='*/.claude/*' \
        /media/share1/carts \
        /media/share1/software/coco* \
        /media/share1/software/dragon* \
        /media/share1/software/mc10* \
        /media/share1/samples/floppy \
        /media/share1/source/ASM \
        /media/share1/source/BASIC \
        /media/share1/source/BASIC09 \
        /media/share1/source/C \
        /media/share1/source/ugBasic \
        /media/share1/source/MC-10 \
        /media/share1/HDBDOS \
        2>/dev/null && echo "[OK]" || echo "[WARN]"
else
    echo "[SKIP] (/media/share1 not mounted)"
fi

run_tar misc-system-files.tar.gz /etc/samba/smb.conf

# ------------------------------------------------------------
# Capture .bashrc CoCo-Pi section
# ------------------------------------------------------------
echo ""
echo "--- Capturing .bashrc modifications ---"
awk '
  /# START of CoCo-Pi modifications/ { in_coco=1; next }
  /# END of CoCo-Pi modifications/   { in_coco=0 }

  /# START of non-CoCo related environment variables/ { in_skip=1; next }
  /# END of non-CoCo related environment variables/   { in_skip=0; next }

  in_coco && !in_skip
' "$HOME/.bashrc" > "$REPO_ROOT/bashrc-cocopi.txt" \
    && echo "  [OK] bashrc-cocopi.txt" \
    || echo "  [SKIP] bashrc-cocopi.txt"

# ------------------------------------------------------------
# cocopi-release.txt
# ------------------------------------------------------------
if [[ -f "$HOME/cocopi-release.txt" ]]; then
    cp "$HOME/cocopi-release.txt" "$REPO_ROOT/"
    echo "  [OK] cocopi-release.txt"
fi

echo ""
echo "=== Installer repo update complete. Review changes and commit. ==="
