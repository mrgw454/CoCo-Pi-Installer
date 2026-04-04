#!/usr/bin/env python3
import os
import sys
import json
import curses
import subprocess
import shlex
import socket
import platform
import random
import re
import time
import base64
import urllib.request
from pathlib import Path

# ---------------- Platform detection ----------------

IS_WINDOWS = (os.name == "nt")
IS_LINUX = (os.name == "posix" and platform.system() == "Linux")
IS_RPI = IS_LINUX and platform.machine() == "aarch64"

# ---------------- User home directories ----------------

WIN_HOME = os.environ.get("USERPROFILE", "")
LIN_HOME = os.environ.get("HOME", "")

# ============================================================
# User-configurable paths
# ============================================================
# Edit the values in this section to match your environment
# before sharing this launcher with others.
#
# Linux:   use standard Unix paths.
# Windows: use forward slashes (e.g. C:/Users/Ron/...) — the
#          launcher converts separators where emulators require it.
# ============================================================

# --- Shared media/ROM library root ({SHARE1} placeholder in JSON) ---
SHARE1_LINUX   = "/media/share1"
SHARE1_WINDOWS = "E:/media/share1"

# --- Emulator locations ---
# Linux:   bare command name (resolved via PATH) or a full path.
# Windows: full path to the .exe file.
XROAR_EXE_LINUX   = "xroar"
XROAR_EXE_WINDOWS = os.path.join(WIN_HOME, "xroar", "xroar.exe")

MAME_EXE_LINUX    = "mame"
MAME_EXE_WINDOWS  = os.path.join(WIN_HOME, "mame", "mame.exe")

TRS80GP_EXE_LINUX   = "trs80gp"
TRS80GP_EXE_WINDOWS = os.path.join(WIN_HOME, "trs80gp", "trs80gp.exe")

VCC_EXE_WINDOWS  = os.path.join(WIN_HOME, "VCC", "VCC.exe")

OVCC_EXE_LINUX = os.path.join(LIN_HOME, ".ovcc", "ovcc")
OVCC_DIR_LINUX = os.path.join(LIN_HOME, ".ovcc")

# --- Version selector search directories (Linux only) ---
# Each directory should contain versioned sub-dirs/files named mame-<ver>/ and xroar-<ver>.
# Windows search dirs are derived automatically from the exe paths above.
MAME_VERSIONS_DIR_LINUX  = "/opt"            # e.g. /opt/mame-0.270/, /opt/mame-0.271/
XROAR_VERSIONS_DIR_LINUX = "/usr/local/bin"  # e.g. /usr/local/bin/xroar-0.40.3 (files)

# --- MAME ROM search path (-rompath argument) ---
ROMPATH_LINUX   = SHARE1_LINUX + "/roms"
ROMPATH_WINDOWS = os.path.join(WIN_HOME, "roms")

# --- pyDriveWire CLI tool ---
PYDWCLI_LINUX   = os.path.join(LIN_HOME, "pyDriveWire", "pyDwCli")
PYDWCLI_WINDOWS = os.path.join(WIN_HOME, "pyDriveWire", "pyDwCli.bat")

# --- FujiNet-PC (built from source) ---
# Windows: _WIN_USER derives your username from your home directory path.
#          If your MSYS2 home differs from your Windows username, set it manually.
_WIN_USER = os.path.basename(WIN_HOME)
FUJINET_EXE_LINUX   = os.path.join(LIN_HOME, "source", "fujinet-pc-CoCo", "build", "dist", "fujinet")
FUJINET_EXE_WINDOWS = os.path.join(WIN_HOME, "msys64", "home", _WIN_USER, "source", "fujinet-pc-CoCo", "build", "dist", "fujinet.exe")

# ---- Active values for the current platform — do not edit below this line ----
SHARE1      = SHARE1_WINDOWS      if IS_WINDOWS else SHARE1_LINUX
XROAR_EXE   = XROAR_EXE_WINDOWS   if IS_WINDOWS else XROAR_EXE_LINUX
MAME_EXE    = MAME_EXE_WINDOWS    if IS_WINDOWS else MAME_EXE_LINUX
TRS80GP_EXE = TRS80GP_EXE_WINDOWS if IS_WINDOWS else TRS80GP_EXE_LINUX
VCC_EXE     = VCC_EXE_WINDOWS     if IS_WINDOWS else ""
OVCC_EXE    = ""                  if IS_WINDOWS else OVCC_EXE_LINUX
ROMPATH     = ROMPATH_WINDOWS     if IS_WINDOWS else ROMPATH_LINUX
PYDWCLI     = PYDWCLI_WINDOWS     if IS_WINDOWS else PYDWCLI_LINUX
FUJINET_EXE = FUJINET_EXE_WINDOWS if IS_WINDOWS else FUJINET_EXE_LINUX

# ---------------- Base paths ----------------

BASE_DIR = Path(__file__).resolve().parent
CONFIG_DIR = BASE_DIR / "config"

# --- pyDriveWire host (pydw_host.txt in launcher dir, defaults to localhost) ---
# To target a remote pyDriveWire server, create pydw_host.txt containing:
#   hostname or IP only:          192.168.0.20
#   with non-standard port:       192.168.0.20:6801
#   with port and instance:       192.168.0.20:6800:2
# Instance selects which pyDriveWire instance to use for disk operations when
# the remote server has multiple instances (e.g. multiple CoCos on serial ports).
# Defaults to instance 0 if omitted. If the file is absent or empty, the
# launcher uses localhost:6800 instance 0 as usual.
_pydw_host_file = BASE_DIR / "pydw_host.txt"
_pydw_host_raw = "localhost"
if _pydw_host_file.exists():
    _content = _pydw_host_file.read_text(encoding="utf-8").strip()
    if _content:
        _pydw_host_raw = _content

_pydw_parts = _pydw_host_raw.split(":")
if len(_pydw_parts) >= 3:
    PYDW_HOST     = _pydw_parts[0]
    PYDW_PORT     = int(_pydw_parts[1])
    PYDW_INSTANCE = int(_pydw_parts[2])
elif len(_pydw_parts) == 2:
    PYDW_HOST     = _pydw_parts[0]
    PYDW_PORT     = int(_pydw_parts[1])
    PYDW_INSTANCE = 0
else:
    PYDW_HOST     = _pydw_host_raw
    PYDW_PORT     = 6800
    PYDW_INSTANCE = 0

PYDW_URL = f"http://{PYDW_HOST}:{PYDW_PORT}"

if IS_WINDOWS:
    PYDW_PIDFILE = os.path.join(WIN_HOME, "pyDriveWire-logs", "pyDW.pid")

    XROAR_OPT   = os.path.join(WIN_HOME, "xroar",   ".optional_xroar_parameters.txt")
    MAME_OPT    = os.path.join(WIN_HOME, "mame",    ".optional_mame_parameters.txt")
    TRS80GP_OPT = os.path.join(WIN_HOME, "trs80gp", ".optional_trs80gp_parameters.txt")
    VCC_OPT     = os.path.join(WIN_HOME, "VCC",     ".optional_vcc_parameters.txt")

else:
    PYDW_PIDFILE = "/tmp/pyDriveWire.pid"

    XROAR_OPT   = os.path.join(LIN_HOME, ".xroar",   ".optional_xroar_parameters.txt")
    MAME_OPT    = os.path.join(LIN_HOME, ".mame",    ".optional_mame_parameters.txt")
    TRS80GP_OPT = os.path.join(LIN_HOME, ".trs80gp", ".optional_trs80gp_parameters.txt")
    OVCC_OPT    = os.path.join(LIN_HOME, ".ovcc",    ".optional_ovcc_parameters.txt")

TOOLS_DIR = BASE_DIR / "tools"

# ---------------- Optional parameter files ----------------

def load_optional_params(path):
    if not os.path.exists(path):
        return []
    try:
        with open(path, "r", encoding="utf-8") as f:
            line = f.readline().strip()
            return line.split()
    except Exception:
        return []

XROAR_PARAMS  = load_optional_params(XROAR_OPT)
MAME_PARAMS   = load_optional_params(MAME_OPT)
TRS80GP_PARAMS = load_optional_params(TRS80GP_OPT)
VCC_PARAMS    = load_optional_params(VCC_OPT)  if IS_WINDOWS else []
OVCC_PARAMS   = []                             if IS_WINDOWS else load_optional_params(OVCC_OPT)

# ---------------- Placeholder expansion ----------------

def expand_home_placeholders(p):
    if not isinstance(p, str):
        return p
    return (
        p.replace("{HOME}", LIN_HOME)
         .replace("{WINHOME}", WIN_HOME.replace("\\", "/"))
         .replace("{SHARE1}", SHARE1.replace("\\", "/"))
    )

def expand_placeholders_in_item(item):
    # Expand args (no translation, just {HOME}/{WINHOME})
    if "args" in item:
        item["args"] = [expand_home_placeholders(a) for a in item["args"]]

    # Expand platform-specific commands (no translation, just {HOME}/{WINHOME})
    if "platforms" in item:
        for _plat, cfg in item["platforms"].items():
            if "command" in cfg:
                cfg["command"] = expand_home_placeholders(cfg["command"])

    # Expand pyDW
    if "pyDW" in item:
        p = item["pyDW"]
        if "insert" in p:
            if isinstance(p["insert"], str):
                p["insert"] = [expand_home_placeholders(p["insert"])]
            else:
                p["insert"] = [expand_home_placeholders(x) for x in p["insert"]]
        if "disks" in p:
            p["disks"] = {k: expand_home_placeholders(v) for k, v in p["disks"].items()}

# ---------------- Path translation (only for known path fields) ----------------

def translate_path_to_linux(p: str) -> str:
    if not isinstance(p, str):
        return p
    p = expand_home_placeholders(p)
    s = p.replace("\\", "/")

    # Only treat as Windows-style if it has a drive or backslashes
    if "\\" in p or ":" in p:
        win_home_norm = WIN_HOME.replace("\\", "/").lower()

        win_share1 = SHARE1_WINDOWS.replace("\\", "/").lower()
        if s.lower().startswith(win_share1):
            return SHARE1_LINUX + s[len(win_share1):]

        if s.lower().startswith(win_home_norm):
            return LIN_HOME + s[len(win_home_norm):]

    return s

def translate_path_to_windows(p: str) -> str:
    if not isinstance(p, str):
        return p
    p = expand_home_placeholders(p)
    s = p.replace("\\", "/")

    lin_home_norm = LIN_HOME

    # Only treat as Linux-style if it starts with a slash
    if s.startswith("/"):
        lin_share1 = SHARE1_LINUX.lower()
        if s.lower().startswith(lin_share1):
            win_share1 = SHARE1_WINDOWS.replace("/", "\\")
            return win_share1 + s[len(lin_share1):].replace("/", "\\")

        if s.lower().startswith(lin_home_norm.lower()):
            return WIN_HOME + s[len(lin_home_norm):].replace("/", "\\")

    return s

def translate_path(p: str) -> str:
    p = expand_home_placeholders(p)
    return translate_path_to_windows(p) if IS_WINDOWS else translate_path_to_linux(p)

def translate_args(args):
    # Args are emulator options / literals; do NOT translate them.
    return list(args)

def translate_pydw(pydw):
    if not isinstance(pydw, dict):
        return pydw
    out = dict(pydw)
    if "insert" in out:
        ins = out["insert"]
        if isinstance(ins, str):
            out["insert"] = [translate_path(ins)]
        else:
            out["insert"] = [translate_path(x) for x in ins]
    if "disks" in out and isinstance(out["disks"], dict):
        out["disks"] = {str(k): translate_path(v) for k, v in out["disks"].items()}
    return out

# ---------------- Load menu ----------------

def load_menu():
    categories = []
    if not CONFIG_DIR.exists():
        return categories

    for filename in sorted(os.listdir(CONFIG_DIR)):
        if not filename.lower().endswith(".json"):
            continue
        path = CONFIG_DIR / filename
        try:
            with open(path, "r", encoding="utf-8") as f:
                data = json.load(f)
        except Exception:
            continue

        title = data.get("title", filename)
        items = data.get("items", [])
        final_items = []

        for it in items:
            # Skip hidden items for this platform
            if "platforms" in it:
                plat = "windows" if IS_WINDOWS else "linux"
                plat_cfg = it["platforms"].get(plat, {})
                if plat_cfg.get("hidden", False):
                    continue

            # Skip items that require a remote pyDW when running locally
            if it.get("hidden_when_pydw_local") and PYDW_HOST == "localhost":
                continue

            # Skip items that are Raspberry Pi (aarch64) only
            if it.get("hidden_when_not_rpi") and not IS_RPI:
                continue

            expand_placeholders_in_item(it)
            it["args"] = translate_args(it.get("args", []))

            if "pyDW" in it:
                it["pyDW"] = translate_pydw(it["pyDW"])

            final_items.append(it)

        if final_items:
            categories.append({"title": title, "items": final_items})

    return categories

# ---------------- Release / Model info ----------------

def get_release_info():
    path = Path(LIN_HOME if IS_LINUX else WIN_HOME) / "cocopi-release.txt"
    if path.exists():
        try:
            return path.read_text(encoding="utf-8").strip()
        except Exception:
            return "CoCo-Pi Release: unreadable"
    return "CoCo-Pi Release: missing"

_MODEL_CACHE = None

def _detect_model():
    if IS_LINUX:
        try:
            raw = Path("/proc/device-tree/model").read_text(encoding="utf-8", errors="replace").strip("\x00").strip()
            rpi = raw[13:16]
            labels = {"500": "RPi500", "5 M": "RPi5", "400": "RPi400", "4 M": "RPi4", "3 M": "RPi3"}
            if rpi in labels:
                return labels[rpi]
            if raw:
                return raw
        except (FileNotFoundError, OSError):
            pass
        try:
            r = subprocess.run(["lscpu"], capture_output=True, text=True, timeout=3)
            for line in r.stdout.splitlines():
                if line.startswith("Model name"):
                    return line.split(":", 1)[1].strip()
        except Exception:
            pass
        return "Linux (unknown model)"
    else:
        try:
            r = subprocess.run(
                ["powershell", "-NoProfile", "-Command",
                 "(Get-CimInstance Win32_ComputerSystem).Model"],
                capture_output=True, text=True, timeout=5
            )
            model = r.stdout.strip()
            if model:
                return model
        except Exception:
            pass
        return "Windows (unknown model)"

def get_model_info():
    global _MODEL_CACHE
    if _MODEL_CACHE is None:
        _MODEL_CACHE = _detect_model()
    return _MODEL_CACHE

def get_git_info():
    script_dir = Path(__file__).resolve().parent
    # Try live git first (works when running directly from the repo)
    try:
        result = subprocess.run(
            ["git", "-C", str(script_dir), "log", "-1", "--format=%h %ad", "--date=short"],
            capture_output=True, text=True, timeout=3
        )
        if result.returncode == 0:
            info = result.stdout.strip()
            if info:
                return f"Launcher: {info}"
    except Exception:
        pass
    # Fall back to git_info.txt written by the sync script at deploy time
    git_info_file = script_dir / "git_info.txt"
    if git_info_file.exists():
        try:
            info = git_info_file.read_text(encoding="utf-8").strip()
            if info:
                return f"Launcher: {info}"
        except Exception:
            pass
    return "Launcher: unknown"

# ---------------- pyDriveWire helpers ----------------

def run_pydw(args):
    cmd = [PYDWCLI, PYDW_URL] + args
    try:
        subprocess.call(cmd)
    except FileNotFoundError:
        pass

def pydw_set_server_mode(server, mode):
    if server is None or mode is None:
        return
    run_pydw(["dw", "server", str(server), str(mode)])

def pydw_mount_disk_slot(slot, path):
    if path:
        run_pydw(["dw", "disk", "insert", str(slot), path])

def pydw_eject_slot(slot):
    run_pydw(["dw", "disk", "eject", str(slot)])

def pydw_eject_slots(slots):
    for s in slots:
        pydw_eject_slot(s)

def validate_pydw_paths(pydw):
    missing = []
    planned = []
    if not pydw:
        return missing, planned
    if "insert" in pydw:
        slot = int(pydw.get("slot", 0))
        for path in pydw["insert"]:
            planned.append((slot, path))
            if not os.path.exists(path):
                missing.append(path)
    if "disks" in pydw:
        for s, path in pydw["disks"].items():
            slot = int(s)
            planned.append((slot, path))
            if not os.path.exists(path):
                missing.append(path)
    return missing, planned

def pydw_pre_launch(pydw):
    if not pydw:
        return
    if PYDW_INSTANCE != 0:
        run_pydw(["dw", "instance", "select", str(PYDW_INSTANCE)])
    if pydw.get("server") is not None and pydw.get("mode") is not None:
        pydw_set_server_mode(pydw["server"], pydw["mode"])
    missing, _ = validate_pydw_paths(pydw)
    if missing:
        print("pyDriveWire: missing DSK files:")
        for m in missing:
            print(" ", m)
        return
    if "insert" in pydw:
        slot = int(pydw.get("slot", 0))
        pydw_eject_slot(slot)
        for path in pydw["insert"]:
            pydw_mount_disk_slot(slot, path)
        return
    if "disks" in pydw:
        slots = sorted(int(s) for s in pydw["disks"].keys())
        pydw_eject_slots(slots)
        for s, path in pydw["disks"].items():
            pydw_mount_disk_slot(int(s), path)

def pydw_upload_and_mount(dsk_path, slot):
    """Upload a local DSK file to the remote pyDW server and mount it in one step.
    Uses the /upload HTTP endpoint so the file does not need to exist on the
    remote host's filesystem — pyDW saves it to its /tmp and mounts from there.
    """
    if PYDW_INSTANCE != 0:
        run_pydw(["dw", "instance", "select", str(PYDW_INSTANCE)])
    try:
        with open(dsk_path, "rb") as f:
            raw = f.read()
        b64 = base64.b64encode(raw).decode("ascii")
        body = f",{b64}".encode("ascii")
        name = Path(dsk_path).name
        url = f"{PYDW_URL}/upload?name={name}&drive={slot}"
        req = urllib.request.Request(url, data=body)
        req.add_header("Content-Type", "application/octet-stream")
        req.add_header("Content-Length", str(len(body)))
        with urllib.request.urlopen(req, timeout=10) as resp:
            print(resp.read().decode("utf-8", errors="replace").strip())
    except Exception as exc:
        print(f"Upload failed: {exc}")

def pydw_post_launch(pydw):
    if not pydw:
        return
    if pydw.get("eject"):
        if "insert" in pydw:
            slot = int(pydw.get("slot", 0))
            pydw_eject_slot(slot)
        elif "disks" in pydw:
            slots = sorted(int(s) for s in pydw["disks"].keys())
            pydw_eject_slots(slots)
    if pydw.get("server") is not None and pydw.get("restoreMode") is not None:
        pydw_set_server_mode(pydw["server"], pydw["restoreMode"])

# ---------------- pyDriveWire runtime status ----------------

def check_pid_running(pid):
    if IS_WINDOWS:
        try:
            result = subprocess.run(
                ["tasklist", "/FI", f"PID eq {pid}"],
                stdout=subprocess.PIPE,
                stderr=subprocess.DEVNULL,
                text=True
            )
            return str(pid) in result.stdout
        except Exception:
            return False
    else:
        try:
            result = subprocess.run(
                ["ps", "-p", str(pid)],
                stdout=subprocess.DEVNULL,
                stderr=subprocess.DEVNULL,
            )
            return result.returncode == 0
        except Exception:
            return False

def check_http_alive():
    try:
        with socket.create_connection((PYDW_HOST, PYDW_PORT), timeout=0.2):
            return True
    except OSError:
        return False

def check_pydw_api():
    try:
        result = subprocess.run(
            [PYDWCLI, PYDW_URL, "dw", "disk", "list"],
            stdout=subprocess.DEVNULL,
            stderr=subprocess.DEVNULL,
            timeout=0.3
        )
        return result.returncode == 0
    except subprocess.TimeoutExpired:
        return False
    except Exception:
        return False

def get_pydw_status_lines():
    lines = []
    if PYDW_HOST != "localhost":
        if check_http_alive():
            lines.append(f"pyDriveWire: running on {PYDW_HOST}")
        else:
            lines.append(f"pyDriveWire: not reachable ({PYDW_HOST})")
    elif not os.path.exists(PYDW_PIDFILE):
        lines.append("pyDriveWire: not running")
    else:
        try:
            with open(PYDW_PIDFILE, "r", encoding="utf-8") as f:
                pid_str = f.read().strip()
        except Exception:
            pid_str = ""

        if not pid_str.isdigit():
            lines.append("pyDriveWire: PID file invalid")
        else:
            pid = int(pid_str)
            if check_pid_running(pid):
                lines.append(f"pyDriveWire: running (PID {pid})")
            else:
                lines.append("pyDriveWire: stale PID (not running)")

    if check_http_alive():
        lines.append("pyDW HTTP: OK")
    else:
        lines.append("pyDW HTTP: unreachable")

    if check_pydw_api():
        lines.append("pyDW API: OK")
    else:
        lines.append("pyDW API: offline")

    lines.append("------------------------------")
    return lines

# ---------------- FujiNet-PC runtime status ----------------

def check_fujinet_running():
    if IS_WINDOWS:
        try:
            result = subprocess.run(
                ["tasklist", "/FI", "IMAGENAME eq fujinet.exe"],
                stdout=subprocess.PIPE,
                stderr=subprocess.DEVNULL,
                text=True
            )
            return "fujinet.exe" in result.stdout.lower()
        except Exception:
            return False
    else:
        try:
            result = subprocess.run(
                ["pgrep", "-f", "fujinet"],
                stdout=subprocess.DEVNULL,
                stderr=subprocess.DEVNULL
            )
            return result.returncode == 0
        except Exception:
            return False

def get_fujinet_status_lines():
    lines = []
    if check_fujinet_running():
        lines.append("FujiNet-PC: running")
    else:
        lines.append("FujiNet-PC: not running")
    return lines

# ---------------- TNFS runtime status ----------------

def check_tnfs_running():
    try:
        result = subprocess.run(
            ["pgrep", "-f", "tnfsd"],
            stdout=subprocess.DEVNULL,
            stderr=subprocess.DEVNULL
        )
        return result.returncode == 0
    except Exception:
        return False

def get_tnfs_status_lines():
    lines = []

    if IS_WINDOWS:
        # Windows: standalone tnfsd.exe installed by installer
        try:
            result = subprocess.run(
                ["tasklist", "/FI", "IMAGENAME eq tnfsd.exe"],
                stdout=subprocess.PIPE,
                stderr=subprocess.DEVNULL,
                text=True
            )
            if "tnfsd.exe" in result.stdout.lower():
                lines.append("TNFS Server: running")
            else:
                lines.append("TNFS Server: not running")
        except Exception:
            lines.append("TNFS Server: status unknown")
        return lines

    # Linux: tnfsd is a separate daemon
    try:
        out = subprocess.check_output(["pgrep", "-f", "tnfsd"], stderr=subprocess.DEVNULL).decode().strip()
        pid = out.split("\n")[0]
        lines.append(f"TNFS Server: running (PID {pid})")
    except subprocess.CalledProcessError:
        lines.append("TNFS Server: not running")
    except Exception:
        lines.append("TNFS Server: status unknown")

    return lines

# ---------------- VCC ini helpers ----------------

_VCC_APPDATA_INI = Path(os.environ.get("APPDATA", "")) / "VCC" / "Vcc.ini"

def _deploy_vcc_ini(working_path):
    """Copy working ini to AppData so VCC doesn't read stale state from there."""
    try:
        if _VCC_APPDATA_INI.parent.exists():
            _VCC_APPDATA_INI.write_bytes(Path(working_path).read_bytes())
    except Exception:
        pass


def prepare_vcc_working_ini(template_ini_path):
    """
    Copy template to vcc_working.ini alongside it and sync to AppData.
    Returns the path to the working copy.
    """
    template_path = Path(expand_home_placeholders(template_ini_path))
    if not template_path.exists():
        raise FileNotFoundError(
            f"VCC ini template not found: {template_path}\n"
            "Create it: launch VCC, configure the scenario, then File -> Save Config."
        )
    working_path  = template_path.parent / "vcc_working.ini"
    working_path.write_bytes(template_path.read_bytes())
    _deploy_vcc_ini(working_path)
    return str(working_path)


def patch_vcc_ini_for_dsk(template_ini_path, dsk_path):
    """
    Copy template ini to vcc_working.ini alongside it, patching [FD-502] Disk#0
    with the given disk image path.  Returns the path to the working copy.
    """
    template_path = Path(expand_home_placeholders(template_ini_path))
    working_path  = template_path.parent / "vcc_working.ini"
    dsk_str       = str(dsk_path).replace("/", "\\")

    lines     = template_path.read_text(encoding="utf-8", errors="replace").splitlines()
    new_lines = []
    in_fd502        = False
    disk0_updated   = False

    for line in lines:
        stripped = line.strip()
        if stripped.startswith("["):
            in_fd502 = (stripped.upper() == "[FD-502]")
        if in_fd502 and re.match(r"(?i)^Disk#0\s*=", stripped):
            line = f"Disk#0={dsk_str}"
            disk0_updated = True
        new_lines.append(line)

    if in_fd502 and not disk0_updated:
        # [FD-502] existed but had no Disk#0 line — append it
        new_lines.append(f"Disk#0={dsk_str}")
    elif not disk0_updated:
        # No [FD-502] section at all — append the whole section
        new_lines += ["", "[FD-502]", f"Disk#0={dsk_str}"]

    working_path.write_text("\n".join(new_lines) + "\n", encoding="utf-8")
    _deploy_vcc_ini(working_path)
    return str(working_path)


# ---------------- OVCC ini helpers ----------------
# OVCC has no -i flag; it reads Vcc.ini from its working directory (~/.ovcc).
# We deploy the template to that location before every launch.

_OVCC_ACTIVE_INI = Path(OVCC_DIR_LINUX) / "Vcc.ini"

def prepare_ovcc_working_ini(template_ini_path):
    """Copy template to ~/.ovcc/Vcc.ini so OVCC reads the right config."""
    template_path = Path(expand_home_placeholders(template_ini_path))
    if not template_path.exists():
        raise FileNotFoundError(
            f"OVCC ini template not found: {template_path}\n"
            "Create it: launch OVCC, configure the scenario, then copy ~/.ovcc/Vcc.ini"
            f" to {template_path}."
        )
    _OVCC_ACTIVE_INI.write_bytes(template_path.read_bytes())


def patch_ovcc_ini_for_dsk(template_ini_path, dsk_path):
    """
    Copy template ini to ~/.ovcc/Vcc.ini, patching [FD-502] Disk#0
    with the given disk image path (Linux forward-slash paths).
    """
    template_path = Path(expand_home_placeholders(template_ini_path))
    dsk_str       = str(dsk_path)

    lines     = template_path.read_text(encoding="utf-8", errors="replace").splitlines()
    new_lines = []
    in_fd502      = False
    disk0_updated = False

    for line in lines:
        stripped = line.strip()
        if stripped.startswith("["):
            in_fd502 = stripped.upper().startswith("[FD502")
        if in_fd502 and re.match(r"(?i)^Disk#0\s*=", stripped):
            line = f"Disk#0={dsk_str}"
            disk0_updated = True
        new_lines.append(line)

    if in_fd502 and not disk0_updated:
        new_lines.append(f"Disk#0={dsk_str}")
    elif not disk0_updated:
        new_lines += ["", "[FD502 26-133]", f"Disk#0={dsk_str}"]

    _OVCC_ACTIVE_INI.write_text("\n".join(new_lines) + "\n", encoding="utf-8")


# ---------------- Command building ----------------

def build_command(item):
    expand_placeholders_in_item(item)

    # ---------------------------------------------------------
    # NEW: Merge OS-specific args + pyDW (this is what broke)
    # ---------------------------------------------------------
    plat = "windows" if IS_WINDOWS else "linux"

    # Start with top-level args (may be empty)
    args = item.get("args", [])

    # If OS-specific args exist, override them
    if plat in item:
        os_block = item[plat]

        if "args" in os_block:
            args = os_block["args"]

        # Expand {HOME}/{WINHOME} inside OS-specific args
        args = [expand_home_placeholders(a) for a in args]
			
        # Merge OS-specific pyDW then expand its paths (expand_placeholders_in_item
        # already ran above but only saw the top-level pyDW block; the platform
        # block is assigned here, so expand it now before validate_pydw_paths runs)
        if "pyDW" in os_block:
            item["pyDW"] = os_block["pyDW"]
            p = item["pyDW"]
            if "insert" in p:
                p["insert"] = [expand_home_placeholders(x) for x in
                               ([p["insert"]] if isinstance(p["insert"], str) else p["insert"])]
            if "disks" in p:
                p["disks"] = {k: expand_home_placeholders(v) for k, v in p["disks"].items()}

    # ---------------------------------------------------------
    # Platform-specific command override (unchanged)
    # ---------------------------------------------------------
    if "platforms" in item:
        plat_cfg = item["platforms"].get(plat)
        if plat_cfg and "command" in plat_cfg:
            cmd = expand_home_placeholders(plat_cfg["command"])
            return shlex.split(cmd)

    emu = item.get("emulator")
    machine = item.get("machine")

    # ---------------------------------------------------------
    # Emulator command builders (unchanged)
    # ---------------------------------------------------------
    if emu == "xroar":
        fixed_args = []
        for a in args:
            if isinstance(a, str):
                if IS_WINDOWS:
                    fixed_args.append(a.replace("\\", "/"))
                else:
                    fixed_args.append(a)
            else:
                fixed_args.append(a)

        xroar_exe = XROAR_EXE.replace("\\", "/") if IS_WINDOWS else XROAR_EXE
        return [xroar_exe, "-default-machine", machine] + fixed_args + XROAR_PARAMS

    elif emu == "mame":
        return [MAME_EXE, machine, "-rompath", ROMPATH] + args + MAME_PARAMS

    elif emu == "trs80gp":
        return [TRS80GP_EXE, f"-{machine}"] + TRS80GP_PARAMS + args

    elif emu == "vcc":
        ini = item.get("vcc_ini", "")
        if ini:
            ini = expand_home_placeholders(ini).replace("/", "\\")
            return [VCC_EXE] + VCC_PARAMS + ["-i", ini]
        return [VCC_EXE] + VCC_PARAMS

    elif emu == "ovcc":
        # OVCC reads Vcc.ini from cwd (~/.ovcc); ini is deployed before launch.
        return [OVCC_EXE] + OVCC_PARAMS

    elif emu == "browser":
        return args[:]

    elif emu == "utility":
        if args and args[0] == "build_dsk":
            return [sys.executable, str(TOOLS_DIR / "build_dsk.py")]
        if args and args[0] == "build_cassette":
            return [sys.executable, str(TOOLS_DIR / "build_cassette.py")]
        # Replace any bare python/python3 with the running interpreter so the
        # correct pyenv version is always used on both Windows and Linux.
        _PY_ALIASES = {"python", "python3", "python.exe", "python3.exe"}
        if args and args[0].lower() in _PY_ALIASES:
            return [sys.executable] + [expand_home_placeholders(a) for a in args[1:]]
        return args[:]

    return ["echo", "unknown emulator type"]

def command_to_string(cmd):
    return " ".join(shlex.quote(str(c)) for c in cmd)

# ---------------- Safe {DSK} substitution ----------------

def substitute_dsk_in_pydw(pydw, dsk_path):
    if not pydw:
        return pydw

    out = json.loads(json.dumps(pydw))

    if "insert" in out:
        out["insert"] = [
            str(path).replace("{DSK}", str(dsk_path))
            for path in out["insert"]
        ]

    if "disks" in out:
        out["disks"] = {
            slot: str(path).replace("{DSK}", str(dsk_path))
            for slot, path in out["disks"].items()
        }

    return out

# ---------------- pyDW preview/status helpers ----------------

def build_pydw_preview_lines(pydw):
    lines = []

    if not pydw:
        lines.append("pyDW: none")
        return lines

    missing, planned = validate_pydw_paths(pydw)

    if pydw.get("server") is not None and pydw.get("mode") is not None:
        lines.append(f"pyDW: server {pydw['server']} mode {pydw['mode']}")
    else:
        lines.append("pyDW: server unchanged")

    if planned:
        for slot, path in planned:
            tag = "MISSING" if path in missing else "OK"
            lines.append(f"  slot {slot}: {path} [{tag}]")
    else:
        lines.append("  no disks configured")

    if pydw.get("eject"):
        lines.append("  eject after exit: yes")
    else:
        lines.append("  eject after exit: no")

    return lines

# ---------------- Attract mode helpers ----------------

def decb_dir_safe(dsk_path: str) -> str:
    """
    Run 'decb dir' safely on Linux and Windows, avoiding drive-letter parsing bugs.
    """
    dsk_path = translate_path(dsk_path)
    p = Path(dsk_path)
    if IS_WINDOWS:
        cwd = str(p.parent) if p.parent else None
        target = p.name
        cmd = ["decb", "dir", target]
        return subprocess.check_output(cmd, text=True, errors="ignore", cwd=cwd)
    else:
        cmd = ["decb", "dir", str(p)]
        return subprocess.check_output(cmd, text=True, errors="ignore")

def parse_dsk_directory(dsk_path: str):
    try:
        out = decb_dir_safe(dsk_path)
    except Exception as e:
        print(f"[DSK] decb dir failed for {dsk_path}: {e}")
        return [], []

    bas_files = []
    bin_files = []

    for line in out.splitlines():
        line = line.strip()
        if not line or line.lower().startswith("directory of"):
            continue

        parts = line.split()
        if len(parts) < 2:
            continue

        name, ext = parts[0], parts[1].upper()
        if ext == "BAS":
            bas_files.append(name)
        elif ext == "BIN":
            bin_files.append(name)

    return bas_files, bin_files

def select_program_from_dsk(dsk_path: str):
    bas_files, bin_files = parse_dsk_directory(dsk_path)

    if bas_files:
        return bas_files[0], "BAS"
    if bin_files:
        return bin_files[0], "BIN"

    return None, None

def collect_files_recursive(root: str, exts):
    root = translate_path(root)
    files = []
    for dirpath, dirnames, filenames in os.walk(root):
        for name in filenames:
            lower = name.lower()
            if any(lower.endswith(e.lower()) for e in exts):
                files.append(os.path.join(dirpath, name))
    return files

def substitute_attract_placeholders(args, file_path, program=None, kind=None, emulator=None):
    # XRoar on Windows requires forward slashes and NO quoting
    if emulator == "xroar":
        file_path = file_path.replace("\\", "/")

    out = []
    for a in args:
        s = str(a)

        # {FILE} for both carts and disks (path already normalized above for xroar)
        if "{FILE}" in s:
            out.append(s.replace("{FILE}", file_path))

        # MAME autoboot
        elif "{AUTOBOOT}" in s and emulator == "mame":
            if program and kind == "BAS":
                out.append(s.replace("{AUTOBOOT}", f'RUN "{program}"\\n'))
            elif program and kind == "BIN":
                out.append(s.replace("{AUTOBOOT}", f'LOADM "{program}":EXEC\\n'))
            else:
                out.append(s.replace("{AUTOBOOT}", ""))

        # XRoar AUTOTYPE
        elif "{AUTOTYPE}" in s and emulator == "xroar":
            if program and kind == "BAS":
                out.append(s.replace("{AUTOTYPE}", f'RUN "{program}"\r'))
            elif program and kind == "BIN":
                out.append(s.replace("{AUTOTYPE}", f'LOADM "{program}"\r\rEXEC\r'))
            else:
                out.append(s.replace("{AUTOTYPE}", ""))

        else:
            out.append(s)

    return out

def run_attract_loop(item, is_slideshow=False):
    emulator = item.get("emulator")
    machine = item.get("machine")
    cfg = item.get("attract", {})

    root = cfg.get("root")
    exts = cfg.get("extensions", [".dsk", ".ccc"])

    if not root:
        print("\n[Attract] Missing 'attract.root' in JSON item.\n")
        input("Press Enter to return to launcher...")
        return

    files = collect_files_recursive(root, exts)
    if not files:
        print(f"\n[Attract] No files found under:\n  {root}\n")
        input("Press Enter to return to launcher...")
        return

    print("\n=== Attract Mode ===\n" if not is_slideshow else "\n=== Slideshow Mode ===\n")
    print("Emulator:", emulator)
    print("Machine :", machine)
    print("Root    :", root)
    print(f"Found   : {len(files)} items")
    print("Press CTRL+C to exit.\n")

    while True:
        file_path = random.choice(files)
        print(f"\nSelected: {file_path}")

        program = None
        kind = None

        lower = file_path.lower()
        if lower.endswith(".dsk"):
            program, kind = select_program_from_dsk(file_path)
            if not program:
                print("[Attract] No BAS/BIN loader found, skipping.")
                time.sleep(1)
                continue

        base_item = {
            "emulator": emulator,
            "machine": machine,
            "args": []
        }
        cmd = build_command(base_item)

        args = substitute_attract_placeholders(
            item.get("args", []),
            file_path,
            program,
            kind,
            emulator
        )

        cmd += args

        print("\n[EMULATOR COMMAND]")
        print(command_to_string(cmd))
        print()

        try:
            proc = subprocess.Popen(cmd)
            proc.wait()
        except KeyboardInterrupt:
            print("\nExiting attract/slideshow mode.\n")
            try:
                proc.terminate()
            except Exception:
                pass
            break
        except Exception as e:
            print(f"[Attract] Error running emulator: {e}")
            time.sleep(2)

def run_attract_item(item):
    run_attract_loop(item, is_slideshow=False)

def run_attract_slideshow_item(item):
    run_attract_loop(item, is_slideshow=True)

# ---------------- Curses helpers ----------------

def _resume_curses():
    """Re-enter curses mode after a temporary curses.endwin(). Returns the new stdscr."""
    stdscr = curses.initscr()
    curses.curs_set(0)
    curses.start_color()
    stdscr.keypad(True)
    # Re-enable mouse: endwin() resets console mode on Windows.
    curses.mousemask(curses.ALL_MOUSE_EVENTS | curses.REPORT_MOUSE_POSITION)
    curses.mouseinterval(200)
    return stdscr

# ---------------- UI layout geometry ----------------

def _compute_layout(max_y, max_x, status_lines, pydw_lines):
    """Return (start_list_y, list_h, left_w) — single source of truth for layout."""
    y = 1
    for _ in status_lines:
        if y >= max_y - 1:
            break
        y += 1
    if y < max_y - 1:
        y += 1  # cwd line
    if y < max_y - 1:
        y += 1  # blank separator
    status_block_height = y
    preview_h = min(2 + len(pydw_lines), max_y // 2)
    list_h = max_y - preview_h - 3
    start_list_y = status_block_height + 1
    left_w = max_x // 3
    return start_list_y, list_h, left_w

# ---------------- UI drawing ----------------

def draw_ui(stdscr, categories, cat_index, item_index, preview_cmd, pydw_lines, status_lines,
            cat_scroll=0, item_scroll=0):
    stdscr.clear()
    max_y, max_x = stdscr.getmaxyx()

    curses.init_pair(1, curses.COLOR_GREEN, curses.COLOR_BLACK)
    curses.init_pair(2, curses.COLOR_BLACK, curses.COLOR_GREEN)

    stdscr.border()

    stdscr.attron(curses.color_pair(1))
    stdscr.addstr(0, 2, " CoCo Launcher ")
    stdscr.attroff(curses.color_pair(1))

    y = 1
    for line in status_lines:
        if y >= max_y - 1:
            break
        stdscr.addstr(y, 2, line[:max_x - 4])
        y += 1

    cwd_line = f"Current folder: {Path.cwd()}"
    if y < max_y - 1:
        stdscr.addstr(y, 2, cwd_line[:max_x - 4])
        y += 1

    if y < max_y - 1:
        stdscr.addstr(y, 2, "")
        y += 1

    start_list_y, list_h, left_w = _compute_layout(max_y, max_x, status_lines, pydw_lines)

    header_y = start_list_y - 1
    if header_y < max_y - 1:
        stdscr.attron(curses.color_pair(1))
        stdscr.addstr(header_y, 2, "Categories")
        stdscr.addstr(header_y, left_w + 3, "Items")
        stdscr.attroff(curses.color_pair(1))

    visible = list_h - start_list_y
    for i, cat in enumerate(categories):
        disp = i - cat_scroll
        if disp < 0:
            continue
        if disp >= visible:
            break
        row = start_list_y + disp
        label = cat["title"]
        if i == cat_index:
            stdscr.attron(curses.color_pair(2))
            stdscr.addstr(row, 2, label[:left_w - 3])
            stdscr.attroff(curses.color_pair(2))
        else:
            stdscr.addstr(row, 2, label[:left_w - 3])

    items = categories[cat_index]["items"]
    for i, item in enumerate(items):
        disp = i - item_scroll
        if disp < 0:
            continue
        if disp >= visible:
            break
        row = start_list_y + disp
        label = item.get("label", "")
        if i == item_index:
            stdscr.attron(curses.color_pair(2))
            stdscr.addstr(row, left_w + 3, label[:max_x - left_w - 4])
            stdscr.attroff(curses.color_pair(2))
        else:
            stdscr.addstr(row, left_w + 3, label[:max_x - left_w - 4])

    start_y = list_h + 1
    if start_y < max_y - 2:
        stdscr.attron(curses.color_pair(1))
        stdscr.addstr(start_y, 2, "Command Preview:")
        stdscr.attroff(curses.color_pair(1))

        if start_y + 1 < max_y - 1:
            # Sanitize control characters for preview only
            preview_safe = (
                preview_cmd
                    .replace("\r", "\\r")
                    .replace("\n", "\\n")
                    .replace("\t", "\\t")
            )
            safe_cmd = preview_safe
            stdscr.addstr(start_y + 1, 2, safe_cmd[:max_x - 4])

        if start_y + 2 < max_y - 1:
            stdscr.attron(curses.color_pair(1))
            stdscr.addstr(start_y + 2, 2, "pyDriveWire:")
            stdscr.attroff(curses.color_pair(1))

            line_y = start_y + 3
            for line in pydw_lines:
                if line_y >= max_y - 1:
                    break
                stdscr.addstr(line_y, 2, line[:max_x - 4])
                line_y += 1

    stdscr.refresh()

# ---------------- Modal-style version selection UI ----------------

def run_version_selector_ui(stdscr, title, versions):
    curses.curs_set(0)
    idx = 0

    while True:
        stdscr.clear()
        max_y, max_x = stdscr.getmaxyx()

        curses.init_pair(1, curses.COLOR_GREEN, curses.COLOR_BLACK)
        curses.init_pair(2, curses.COLOR_BLACK, curses.COLOR_GREEN)

        stdscr.border()

        stdscr.attron(curses.color_pair(1))
        stdscr.addstr(0, 2, f" {title} ")
        stdscr.attroff(curses.color_pair(1))

        stdscr.addstr(2, 2, "Use ↑/↓ to choose, Enter to activate, Q to cancel")

        start_y = 4
        for i, v in enumerate(versions):
            label = str(v)
            if i == idx:
                stdscr.attron(curses.color_pair(2))
                stdscr.addstr(start_y + i, 4, label[:max_x - 8])
                stdscr.attroff(curses.color_pair(2))
            else:
                stdscr.addstr(start_y + i, 4, label[:max_x - 8])

        stdscr.refresh()
        key = stdscr.getch()

        if key in (ord('q'), ord('Q')):
            return None

        if key == curses.KEY_UP:
            idx = max(0, idx - 1)
        elif key == curses.KEY_DOWN:
            idx = min(len(versions) - 1, idx + 1)
        elif key in (10, 13, curses.KEY_ENTER):
            return versions[idx]

# ---------------- Main loop ----------------

def main(stdscr):
    curses.curs_set(0)
    curses.start_color()
    stdscr.keypad(True)

    categories = load_menu()
    if not categories:
        stdscr.addstr(0, 0, "No JSON menus found.")
        stdscr.getch()
        return

    cat_index = 0
    item_index = 0
    cat_scroll = 0
    item_scroll = 0

    items = categories[0]["items"]
    current_item = items[0] if items else {}

    preview_cmd = command_to_string(build_command(current_item)) if items else ""
    pydw_lines = build_pydw_preview_lines(current_item.get("pyDW"))

    status_lines = [
        get_release_info(),
        get_model_info(),
        get_git_info(),
    ] + (
        get_pydw_status_lines()
        + get_fujinet_status_lines()
        + get_tnfs_status_lines()
    )

    # Enable mouse AFTER status_lines is computed.  On Windows, the socket
    # call inside get_pydw_status_lines() (check_http_alive) resets the
    # console's ENABLE_MOUSE_INPUT flag that PDCursesMod sets.  Enabling
    # mouse here — after all network checks — ensures it stays set.
    curses.mousemask(curses.ALL_MOUSE_EVENTS | curses.REPORT_MOUSE_POSITION)
    curses.mouseinterval(200)

    def refresh_status():
        nonlocal status_lines
        status_lines = [
            get_release_info(),
            get_model_info(),
            get_git_info(),
        ] + (
            get_pydw_status_lines()
            + get_fujinet_status_lines()
            + get_tnfs_status_lines()
        )

    # Helper to launch an item
    def launch_item(item):
        nonlocal status_lines, stdscr

        # -----------------------------------------------------
        # System actions (version selector)
        # -----------------------------------------------------
        if item.get("type") == "system_action":
            import version_selector

            action = item["action"]
            versions = version_selector.get_versions(action)

            if not versions:
                curses.endwin()
                print(f"No versions found for {action}.")
                input("Press Enter to return to launcher...")
                stdscr = _resume_curses()
                return

            choice = run_version_selector_ui(stdscr, item.get("label", "Select Version"), versions)

            if choice:
                curses.endwin()
                version_selector.activate(action, choice)
                input("\nVersion updated. Press Enter to return to launcher...")
                stdscr = _resume_curses()
                refresh_status()

            return

        # -----------------------------------------------------
        # Attract / Slideshow items
        # -----------------------------------------------------
        if item.get("type") == "attract":
            curses.endwin()
            run_attract_item(item)
            input("Press Enter to return to launcher...")
            stdscr = _resume_curses()
            refresh_status()
            return

        if item.get("type") == "attract_slideshow":
            curses.endwin()
            run_attract_slideshow_item(item)
            input("Press Enter to return to launcher...")
            stdscr = _resume_curses()
            refresh_status()
            return

        # -----------------------------------------------------
        # Normal emulator launch
        # -----------------------------------------------------
        cmd_list = build_command(item)
        cmd_str = command_to_string(cmd_list)
        pydw = item.get("pyDW")

        try:
            if item.get("emulator") == "vcc" and item.get("vcc_ini") and item.get("utility") != "build_dsk":
                # Always launch VCC with a working copy so templates stay pristine
                working_ini = prepare_vcc_working_ini(item["vcc_ini"])
                cmd_list = [VCC_EXE] + VCC_PARAMS + ["-i", working_ini]
                cmd_str = command_to_string(cmd_list)

            if item.get("emulator") == "ovcc" and item.get("ovcc_ini") and item.get("utility") != "build_dsk":
                # Deploy template to ~/.ovcc/Vcc.ini; OVCC reads it from cwd
                prepare_ovcc_working_ini(item["ovcc_ini"])
                cmd_list = [OVCC_EXE] + OVCC_PARAMS
                cmd_str = command_to_string(cmd_list)
        except FileNotFoundError as exc:
            curses.endwin()
            print(f"\nError: {exc}")
            input("\nPress Enter to return to launcher...")
            stdscr = _resume_curses()
            return

        if item.get("utility") == "build_dsk":
            dsk_builder = [sys.executable, str(TOOLS_DIR / "build_dsk.py")]
            subprocess.call(dsk_builder)

            project = Path.cwd()
            dsk_path = project / f"{project.name}.dsk"

            try:
                if item.get("emulator") == "vcc" and item.get("vcc_ini"):
                    if pydw:
                        # pyDW handles disk; just use a clean working copy of the ini
                        working_ini = prepare_vcc_working_ini(item["vcc_ini"])
                    else:
                        # No pyDW: patch Disk#0 in [FD-502]
                        working_ini = patch_vcc_ini_for_dsk(item["vcc_ini"], dsk_path)
                    cmd_list = [VCC_EXE] + VCC_PARAMS + ["-i", working_ini]
                elif item.get("emulator") == "ovcc" and item.get("ovcc_ini"):
                    if pydw:
                        prepare_ovcc_working_ini(item["ovcc_ini"])
                    else:
                        patch_ovcc_ini_for_dsk(item["ovcc_ini"], dsk_path)
                    cmd_list = [OVCC_EXE] + OVCC_PARAMS
                else:
                    cmd_list = [str(c).replace("{DSK}", str(dsk_path)) for c in cmd_list]
            except FileNotFoundError as exc:
                curses.endwin()
                print(f"\nError: {exc}")
                input("\nPress Enter to return to launcher...")
                stdscr = _resume_curses()
                return

            if pydw:
                pydw = substitute_dsk_in_pydw(pydw, dsk_path)
                pydw = translate_pydw(pydw)
                item["pyDW"] = pydw

            cmd_str = command_to_string(cmd_list)

        if item.get("utility") == "build_mount":
            dsk_builder = [sys.executable, str(TOOLS_DIR / "build_dsk.py")]
            subprocess.call(dsk_builder)

            project = Path.cwd()
            dsk_path = project / f"{project.name}.dsk"
            slot = int((pydw or {}).get("slot", 0))

            curses.endwin()
            host_display = f"{PYDW_HOST}:{PYDW_PORT}" + (f" instance {PYDW_INSTANCE}" if PYDW_INSTANCE != 0 else "")
            print(f"\nUploading and mounting on {host_display}...")
            pydw_upload_and_mount(dsk_path, slot)
            print(f"File: {dsk_path.name}")
            input("\nPress Enter to return to launcher...")
            stdscr = _resume_curses()
            refresh_status()
            return

        curses.endwin()
        print("\nLaunching:")

        # cmd_str is the real command string; sanitize only for display
        launching_display = (
            cmd_str
                .replace("\r", "\\r")
                .replace("\n", "\\n")
                .replace("\t", "\\t")
        )
        print(launching_display)
        print()

        launch_cwd = OVCC_DIR_LINUX if (item.get("emulator") == "ovcc" and IS_LINUX) else None
        pydw_pre_launch(pydw)
        try:
            subprocess.call(cmd_list, cwd=launch_cwd)
        finally:
            pydw_post_launch(pydw)

        refresh_status()

        input("\nPress Enter to return to launcher...")
        stdscr = _resume_curses()

    # ---------------- MAIN LOOP ----------------
    while True:

        max_y, max_x = stdscr.getmaxyx()
        start_list_y, list_h, left_w = _compute_layout(max_y, max_x, status_lines, pydw_lines)
        visible = max(1, list_h - start_list_y)

        try:
            draw_ui(
                stdscr, categories, cat_index, item_index,
                preview_cmd, pydw_lines, status_lines,
                cat_scroll, item_scroll
            )
        except curses.error:
            pass  # terminal too small to draw; wait for resize or input

        key = stdscr.getch()

        if key in (ord('q'), ord('Q'), 27, curses.KEY_F10, 24):
            break

        if key == curses.KEY_UP:
            item_index = max(0, item_index - 1)
            if item_index < item_scroll:
                item_scroll = item_index

        elif key == curses.KEY_DOWN:
            items = categories[cat_index]["items"]
            if items:
                item_index = min(len(items) - 1, item_index + 1)
                if item_index >= item_scroll + visible:
                    item_scroll = item_index - visible + 1

        elif key == curses.KEY_LEFT:
            cat_index = max(0, cat_index - 1)
            item_index = 0
            item_scroll = 0
            if cat_index < cat_scroll:
                cat_scroll = cat_index

        elif key == curses.KEY_RIGHT:
            cat_index = min(len(categories) - 1, cat_index + 1)
            item_index = 0
            item_scroll = 0
            if cat_index >= cat_scroll + visible:
                cat_scroll = cat_index - visible + 1

        elif key in (curses.KEY_ENTER, 10, 13):
            items = categories[cat_index]["items"]
            if items:
                launch_item(items[item_index])

        elif key == curses.KEY_RESIZE:
            curses.resize_term(*stdscr.getmaxyx())

        elif key == curses.KEY_MOUSE:
            try:
                _, mx, my, _, bstate = curses.getmouse()
            except curses.error:
                continue

            scroll_up   = bool(bstate & getattr(curses, "BUTTON4_PRESSED", 0))
            scroll_down = bool(bstate & getattr(curses, "BUTTON5_PRESSED", 0))

            if scroll_up or scroll_down:
                delta = -1 if scroll_up else 1
                if mx < left_w:
                    # Scroll wheel in category pane
                    cat_index = max(0, min(len(categories) - 1, cat_index + delta))
                    item_index = 0
                    item_scroll = 0
                    if cat_index < cat_scroll:
                        cat_scroll = cat_index
                    elif cat_index >= cat_scroll + visible:
                        cat_scroll = cat_index - visible + 1
                else:
                    # Scroll wheel in item pane
                    items = categories[cat_index]["items"]
                    if items:
                        item_index = max(0, min(len(items) - 1, item_index + delta))
                        if item_index < item_scroll:
                            item_scroll = item_index
                        elif item_index >= item_scroll + visible:
                            item_scroll = item_index - visible + 1

            elif start_list_y <= my < list_h:
                if 2 <= mx < left_w:
                    # Category click
                    i = (my - start_list_y) + cat_scroll
                    if 0 <= i < len(categories):
                        cat_index = i
                        item_index = 0
                        item_scroll = 0
                        if cat_index < cat_scroll:
                            cat_scroll = cat_index
                        elif cat_index >= cat_scroll + visible:
                            cat_scroll = cat_index - visible + 1

                elif mx >= left_w + 3:
                    # Item click
                    i = (my - start_list_y) + item_scroll
                    items = categories[cat_index]["items"]
                    if items and 0 <= i < len(items):
                        item_index = i
                        if item_index < item_scroll:
                            item_scroll = item_index
                        elif item_index >= item_scroll + visible:
                            item_scroll = item_index - visible + 1
                        if bstate & getattr(curses, "BUTTON1_DOUBLE_CLICKED", 0):
                            launch_item(items[item_index])

        # Update preview (not status)
        items = categories[cat_index]["items"]
        if items:
            current_item = items[item_index]
            preview_cmd = command_to_string(build_command(current_item))
            pydw_lines = build_pydw_preview_lines(current_item.get("pyDW"))
        else:
            preview_cmd = ""
            pydw_lines = ["pyDW: none"]

if __name__ == "__main__":
    print(f"\nCurrent project folder: {Path.cwd()}\n")

    curses.wrapper(main)
