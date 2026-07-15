# CoCo-Pi Installer for Debian 13

## Building a CoCo workstation on a current operating system

The CoCo-Pi Installer is the reproducible build and delivery foundation for the
current CoCo-Pi environment. On the `debian13` branch, it transforms supported
Debian 13 systems into prepared Color Computer workstations. The project grew
from Raspberry Pi installation work to support Debian 13 on other hardware,
especially x86-64. Connected Launcher and toolchain work has also brought
Windows close to Linux feature parity through Python, PowerShell, MSYS2/MinGW,
and Cygwin, though some platform gaps remain.

This approach preserves what people value about CoCo-Pi—a coordinated set of
emulators, menus, development tools, services, and configuration—while making
the host operating system and installation process easier to understand,
maintain, and rebuild.

## What the installer provides

The installer assembles many independently developed components into one
working environment:

- the CoCo-Pi Launcher and its machine-aware menus;
- emulator configuration for the CoCo, MC-10, Dragon, and related systems;
- XRoar, MAME, trs80gp, and other supported emulators;
- 6809 assemblers, C and BASIC compilers, ToolShed, and media utilities;
- VS Code, CoCo-aware extensions, tasks, and workspace support;
- pyDriveWire, DriveWire, and supporting network services;
- desktop shortcuts, fonts, shell configuration, and shared media layout; and
- update scripts and idempotent fixes for installed systems.

The installer does not distribute machine ROMs that users are not entitled to
use. It prepares the paths and tools through which legally supplied ROMs and
software can be used.

The Installer also does not claim authorship of the independent tools it
builds or packages. Those projects remain the work of their upstream community
developers under their respective licenses. The Installer's role is to encode
how they can be obtained, built, configured, integrated, and maintained as a
coherent CoCo-Pi system.

## The Debian 13 platform work

Current work is based on the `debian13` branch. It targets Raspberry Pi 3 B+,
4, 400, 5, and 500 systems using a 64-bit Raspberry Pi OS desktop as the
preferred Pi base. The same Installer work has expanded to Debian 13 on
x86-64/amd64 computers. Windows is not a target for a Raspberry Pi-style system
image, but most of the CoCo-Pi environment—including the cross-platform
Launcher, emulators, build tools, VS Code integration, and supporting scripts—
now runs there. Native Python and PowerShell handle Windows orchestration,
MSYS2/MinGW supplies many builds, and Cygwin supports toolchains whose build
assumptions remain Unix-oriented. It is close to Linux feature completeness,
not identical to it.

Installation proceeds in visible stages: bootstrap the repository, install
home and desktop assets, configure Python and Rust, install system packages,
build the emulator and development packages, create the Launcher shortcut, and
synchronize VS Code extensions. Reboots between major stages give system-level
changes a predictable boundary.

The reproducible Installer work offers important benefits:

- a current Debian foundation rather than a frozen operating-system snapshot;
- scripts that record how important tools were obtained and built;
- common support for Raspberry Pi and conventional amd64 hosts;
- component and configuration updates without replacing an entire image; and
- a system that can be audited, repaired, and reproduced.

Because the branch is evolving platform work, users should follow its specific
instructions and tested OS recommendations. The obsolete `CoCo-Pi-64bit`
repository should not be mixed into this workflow.

## How the Raspberry Pi SD card relates

The ready-to-use CoCo-Pi SD card is a Raspberry Pi distribution Ron produces
from the Installer-maintained environment. It is intended for enthusiasts who
want the complete CoCo-Pi experience without manually running every setup,
package installation, compilation, and configuration stage.

The SD card and Installer are therefore not competing projects. The Installer
is the reproducible foundation and update machinery; the SD card is a
convenient Raspberry Pi delivery made from that work. SD cards are not being
produced for x86-64 Debian or Windows systems.

## XRoar in the installed environment

XRoar gives the installer unusually broad coverage from one emulator. Its
machine profiles span CoCo 1, CoCo 2, CoCo 3, MC-10/Alice, and Dragon systems,
with support for the relevant video hardware, memory configurations, disks,
tapes, cartridges, joysticks, and expansion devices.

The CoCo-Pi build scripts can build XRoar from source, while its configuration
and ROM paths are preserved as part of the installed environment. The Launcher
then selects the intended machine and media without requiring users to memorize
the corresponding command line.

XRoar also supports serious development. Its GDB remote stub can work with
`m6809-gdb` and VS Code for register, memory, breakpoint, watchpoint, and
instruction-level inspection. Experimental work in the separate Launcher
`feature/xroar-ai-integration` branch adds opt-in rendered-screen observation
and assisted emulator control. That work complements the Debian 13 environment
but is not presented as a standard Installer feature until it is deliberately
packaged and released there.

## Updating an installed CoCo-Pi system

The Installer repository is also the update channel for Raspberry Pi users.
Maintained archives carry Launcher scripts, desktop files, fonts, emulator
configuration, service files, source/build helpers, and selected shared-media
structure. The Launcher exposes maintenance operations that update the local
Installer checkout, deploy the refreshed Launcher package, and apply CoCo-Pi
fixes.

Fixes are versioned and idempotent. An installed system records which fix tags
have completed, allowing the fix script to be safely rerun without repeatedly
applying the same operation. This is particularly useful for a distribution
that coordinates files across the user's home directory, emulator
configuration, and host system.

The source Launcher repository and the public Installer repository have
different roles. Launcher development is maintained in `CoCo-Pi-Launcher`;
selected, reviewed files are packaged into this repository for Pi end users.
That separation lets the Installer remain the public delivery mechanism while
Launcher development can evolve independently.

Packaging is curated rather than a blind home-directory copy. It selects
CoCo-related scripts, desktop assets, fonts, emulator settings, source recipes,
services, and shared media while excluding unrelated systems, transient output,
backups, and development metadata. The current payload includes more than 180
source/build recipes and over 10,000 shared-media entries. The update script
also refreshes Launcher Git provenance and reports missing optional inputs,
making this a reviewable release pipeline rather than merely a set of archives.

## Why the Installer matters

Many retro-computing environments work only because one person remembers a
long sequence of undocumented setup steps. The CoCo-Pi Installer turns those
steps into maintained project assets. It records enough of the host environment
to recreate a workstation while still leaving the underlying Debian system
recognizable and useful.

That makes the installer more than a convenience script. It is the bridge
between the CoCo-Pi project as an idea and a machine someone else can actually
build, update, and use.

For the broader purpose and community story, see
[COCO_PI_PROJECT_OVERVIEW.md](COCO_PI_PROJECT_OVERVIEW.md). For the current
Debian 13 procedure, requirements, and cautions, see [README.md](README.md).
