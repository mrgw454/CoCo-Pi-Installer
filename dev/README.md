# Maintainer Workflow

Files in this directory are for the **repo maintainer only** — not for end users.

---

## Updating the Installer Repo

After making changes to the live system (scripts, launcher, config, etc.) that
should be packaged for Pi end users, regenerate the tarballs from the primary
development machine (Debian 13 x570):

```bash
cd ~/source-CoCo-Pi/CoCo-Pi-Installer
bash dev/CoCo-Pi-Installer-repo-update.sh
```

The script must be run from the repo root — it validates the working directory
and exits if run from anywhere else.

After running:

```bash
git diff --stat          # review what changed
git add -p               # stage selectively
git commit -m "message"
git push
```

---

## What Gets Packaged

| Tarball | Source |
|---|---|
| `scripts.tar.gz` | `~/scripts/` — launcher + all supporting scripts (CoCo/retro only, excludes .ps1/atari/apple/etc) |
| `Desktop.tar.gz` | `~/Desktop` — CoCo/retro-related shortcuts only |
| `Pictures.tar.gz` | `~/Pictures` — CoCo/retro-related images only |
| `fonts.tar.gz` | `~/.fonts` — CoCo/retro fonts only |
| `misc-home-files.tar.gz` | `.vim`, `.wgetrc`, `.irssi`, VS Code `tasks.json` |
| `mame.tar.gz` | `~/.mame` — excludes non-CoCo systems, snap, nvram |
| `xroar.tar.gz` | `~/.xroar` |
| `trs80gp.tar.gz` | `~/.trs80gp` |
| `ovcc.tar.gz` | `~/.ovcc` (skipped if absent) |
| `pyDriveWire-files.tar.gz` | `~/pyDriveWire/` config and scripts |
| `DriveWire-files.tar.gz` | `~/DriveWire4/` config and scripts |
| `tcpser-files.tar.gz` | `~/tcpser/` scripts |
| `source.tar.gz` | `~/source/` — new_windows.zip, *.sh, useroptions.mak, ovcc patch, coco3 patches |
| `media-share1.tar.gz` | `/media/share1/` — specific CoCo/retro subdirs only; excludes dated backup dirs |
| `misc-system-files.tar.gz` | `/etc/samba/smb.conf` |

Also captures:
- `bashrc-cocopi.txt` — CoCo-Pi section of `~/.bashrc` (between START/END markers, skipping non-CoCo env vars)
Also freshens `~/scripts/launcher/git_info.txt` from the CoCo-Pi-Launcher repo HEAD
before building `scripts.tar.gz` — ensures Pi users see the correct launcher git rev.

`fix-cocopi.sh` and `cocopi-release.txt` are edited **manually** and are not
touched by the harvest script.

---

## Adding a Pi Fix

1. Place fix assets in `update/YYYYMMDD/` inside this repo.
2. Add a fix block to `fix-cocopi.sh` before the final "please reboot" message:

```bash
fix="fix-YYYYMMDD-NN"
if grep -q "$fix" $file; then
    echo fix $fix already complete.
    echo
else
    echo Applying fix $fix...
    echo
    cp $HOME/CoCo-Pi-Installer/update/YYYYMMDD/some_file $HOME/destination/
    cd $HOME
    echo "$fix" >>$file
    echo
fi
```

3. Commit fix assets + `fix-cocopi.sh` and push.

Fix tags use the format `fix-YYYYMMDD-NN` (increment NN for multiple same-day
fixes). Applied fixes are tracked in `~/update/cocopi-fixes.txt` on each Pi;
the script is idempotent and safe to re-run.

---

## Pi Update Workflow (end users)

Pi users update via the **Maintenance: Update Utilities** launcher menu:

1. **Update Launcher** — `git pull` on `~/CoCo-Pi-Installer`, then extracts `scripts.tar.gz`
   to `~/` in one atomic step (prevents stale git rev from running steps out of order)
2. **Apply CoCo-Pi Fixes** — runs `fix-cocopi.sh`

**Bootstrap (first time / old launcher without the combined menu item):**

```bash
cd ~/CoCo-Pi-Installer && git pull && tar xzf ~/CoCo-Pi-Installer/scripts.tar.gz -C ~/
```
