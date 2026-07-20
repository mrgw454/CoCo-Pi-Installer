# Maintainer Workflow

Files in this directory are for the **repo maintainer only** — not for end users.

---

## Updating the Installer repository

After making changes to the live system (scripts, launcher, config, etc.) that
should be packaged for Pi end users, run the canonical staged harvest from the
primary development machine (Debian 13 x570):

```bash
cd ~/source-CoCo-Pi/CoCo-Pi-Installer
./create-CoCo-Pi-Installer-packages.sh
```

The script must be run from the repository root. It archives an existing
`CoCo-Pi-Installer-staging/` directory under a timestamped, ignored name and
creates a fresh staging directory. It does not overwrite tracked packages,
stage Git changes, commit, or push.

After harvesting, the script:

1. Checks that every expected archive exists, is nonempty, and passes gzip
   integrity validation.
2. Rejects agent metadata, Git metadata, Python caches, bytecode, and backup
   files in `scripts.tar.gz`.
3. Extracts the staged and tracked archives into temporary directories and
   compares their contents. This avoids treating gzip timestamps or tar
   metadata as package changes.
4. Writes `CoCo-Pi-Installer-staging/PROMOTION-REPORT.txt`, classifying each
   package as `NEW`, `CHANGED`, or `UNCHANGED` and listing content differences.
5. Normalizes a live `Developer Edition` release label to `Community Edition`,
   validates the result, and reports plain-file changes separately.

Review the report and promote only intended content into the repository root.
For example:

```bash
less CoCo-Pi-Installer-staging/PROMOTION-REPORT.txt
cp CoCo-Pi-Installer-staging/scripts.tar.gz ./
cp CoCo-Pi-Installer-staging/source.tar.gz ./
```

Then review and publish manually:

```bash
git diff --stat
git diff --check
git add -p
git commit -m "message"
git push origin debian13
```

Keeping promotion and Git publication manual is intentional. The live
workstation is package input and evidence, but it can also contain local-only
state that must not become part of a public release.

---

## What Gets Packaged

| Tarball | Source |
|---|---|
| `scripts.tar.gz` | `~/scripts/` — launcher + all supporting scripts (CoCo/retro only; excludes .ps1, non-CoCo platforms, agent metadata, Git metadata, and Python caches) |
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

Also captures `bashrc-cocopi.txt`, the CoCo-Pi section of `~/.bashrc` between
its START/END markers while skipping non-CoCo environment variables.

Before harvesting, deploy the intended Launcher revision with the Launcher's
canonical sync script. The Installer harvest packages the deployed
`~/scripts/launcher/` tree; it does not modify or synchronize that tree.

`fix-cocopi.sh` is edited manually. The harvest captures the live
`~/cocopi-release.txt`, but always changes `Developer Edition` to
`Community Edition` in the staged copy. Developer labels must never be
promoted into the public Installer package.

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
