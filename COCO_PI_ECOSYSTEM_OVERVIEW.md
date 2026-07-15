# The CoCo-Pi Ecosystem: From Source Code to a Living Color Computer

## One environment, many connected projects

CoCo-Pi is easy to underestimate. From the outside it may look like a
Raspberry Pi image, an emulator menu, or a collection of utilities. In
practice, it is a connected development and preservation ecosystem for the
TRS-80 Color Computer, MC-10, Dragon, and related 6809 machines.

It brings together a maintained host environment, emulators, original-hardware
services, compilers and assemblers, media tools, software collections, Visual
Studio Code integration, debugging, and reproducible build scripts. Each piece
is useful by itself; CoCo-Pi's distinctive value is that the pieces know how to
work together.

## Built from community achievement

CoCo-Pi does not claim that Ron created all of the emulators, compilers,
assemblers, libraries, services, or media tools it brings together. XRoar,
MAME, ToolShed, lwtools/lwasm, CMOC, ugBASIC, DriveWire, FujiNet, and the many
other included or supported projects are the work of talented community and
open-source developers. Each retains its own authorship, upstream project,
license, history, and community.

Ron's contribution is integration and stewardship: finding useful projects,
working out how to build them on current systems, preserving the required
recipes and configuration, connecting them through shared workflows, packaging
them for others, documenting their use, and maintaining the result as hosts and
dependencies change. CoCo-Pi is powerful because it makes many people's work
more approachable together while respecting where that work came from.

```text
                         CoCo-Pi
                            |
          +-----------------+-----------------+
          |                 |                 |
   Installer/build     CoCo-Pi Launcher    VS Code tools
   and update system   and configuration   and workspaces
          |                 |                 |
          +----------+------+--------+--------+
                     |               |
              Emulators          Development
          XRoar, MAME, etc.   build/package/debug
                     |               |
                     +-------+-------+
                             |
                  Emulated or physical CoCo
```

## CoCo-Pi: the complete workstation

CoCo-Pi is the umbrella project and the user experience. It prepares a modern
computer to explore existing software, develop new programs, study the 6809,
manage vintage media formats, or provide services to original hardware.

The current generation is based on Debian 13. It supports 64-bit Raspberry Pi
systems and Debian 13 on x86-64/amd64 computers. Windows is also close to
feature parity with Linux through a deliberate combination of native Python,
PowerShell, MSYS2/MinGW, and Cygwin. A few platform gaps remain, most notably
the current Linux-first XRoar AI integration.

For Raspberry Pi users who do not want to perform a long manual build, Ron
produces a ready-to-use SD-card distribution from this maintained work. The SD
card is a convenient Raspberry Pi delivery of CoCo-Pi, not a separate source
tree or an image made by undocumented hand configuration.

## CoCo-Pi Installer: the reproducible foundation

The `CoCo-Pi-Installer` repository's `debian13` branch records how the
environment is assembled and maintained. It installs the home and desktop
assets, host packages, runtimes, emulator configuration, development tools,
Launcher, services, and VS Code extensions needed for a working system.

This foundation serves two audiences:

- people who want to build CoCo-Pi themselves on a supported Debian 13 system;
- people who use the Raspberry Pi SD-card distribution produced from that same
  Installer-maintained environment.

The Installer also carries the Raspberry Pi update path. Packaged Launcher
files, emulator settings, fonts, desktop assets, service configuration, shared
media structure, and versioned fixes can be deployed without replacing the
entire card. Idempotent fix tags record completed repairs and make maintenance
repeatable.

## CoCo-Pi Launcher: the common front door

CoCo-Pi Launcher turns the installed components into an approachable system.
Its Python terminal interface reads structured JSON menus describing machines,
emulators, media, services, utilities, and platform-specific options.

From one menu, a user can:

- start CoCo 1, CoCo 2, CoCo 3, MC-10, Dragon, and clone configurations;
- choose XRoar, MAME, trs80gp, VCC, or OVCC where supported;
- build, inspect, extract, or convert disks and cassette images;
- build a project and launch it in the appropriate emulator;
- upload and mount a project disk through a remote pyDriveWire server;
- start and monitor DriveWire, FujiNet-PC, and TNFS services;
- select installed emulator versions;
- audit paths, ROM configuration, menus, and VS Code tasks; and
- download or update supported software collections.

The Launcher is cross-platform across Linux and Windows, with WSL2 support as
well. PowerShell performs native Windows deployment and orchestration;
MSYS2/MinGW builds XRoar and many development tools; Cygwin supplies the Unix
environment required by toolchains such as CMOC. The project keeps platform-
specific paths and commands behind one shared menu model.

The Launcher is also configuration-driven. Much of
CoCo-Pi's accumulated knowledge lives in the configurations: which machine a
program expects, which peripheral belongs in a slot, which media should be
mounted, and which startup command completes the experience.

## XRoar: the flexible machine at the center

XRoar has a special place in the ecosystem because one emulator covers a broad
range of CoCo, MC-10/Alice, and Dragon machines. It handles VDG and GIME video,
disks, tapes, cartridges, joysticks, memory configurations, and expansion
hardware while remaining highly controllable from scripts and command lines.

That flexibility lets the same CoCo-Pi workflow serve a CoCo 2 BASIC disk, a
CoCo 3 graphics program, an MC-10 cassette, a Dragon title, or a peripheral
experiment. The Launcher chooses the intended configuration; XRoar provides
the emulated machine.

XRoar also connects ordinary use to serious development. Its GDB remote stub,
used with `m6809-gdb`, allows register and memory inspection, stepping,
breakpoints, and watchpoints from VS Code.

The experimental XRoar AI build extends that connection. It adds opt-in,
loopback-only rendered-screen observation, deterministic keyboard and joystick
control, approved media operations, snapshots, and structured session state.
The Launcher has separate capability-checked XRoar AI entries, and its VS Code
extension can discover the emulator belonging to the current workspace,
capture its screen, record changed frames, show activity, and coordinate with
GDB ownership.

XRoar AI does not replace normal XRoar or GDB. It joins visible emulator
behavior to CPU and memory evidence. Tests with Rogue and Oregon Trail showed
why that matters: one investigation corrected stale memory assumptions; the
other traced graphical corruption to a measured overlap between a growing
BASIC program and its machine-language font engine.

## VS Code: where source meets the machine

CoCo-Pi's VS Code support makes classic-computer development feel like a
coherent project rather than a chain of unrelated commands.

The included extensions and templates provide:

- syntax support for CoCo BASIC, MC-10/MCX BASIC, ugBASIC, BASIC-to-6809, and
  6809/6309 assembly workflows;
- keyword documentation, more than 600 snippets, and PEEK/POKE/EXEC memory-map
  information;
- 6809/6309 instruction descriptions, addressing modes, cycle counts, flags,
  and HD6309 notes;
- tasks for BASIC renumbering, lwasm, asm6809, CMOC, mcbasic, ugBASIC, and
  BASIC-to-6809;
- project-specific workspace settings and XRoar GDB launch templates; and
- a Launcher button plus experimental workspace-aware XRoar AI observation.

A developer can edit a source file, compile or assemble it, package a DSK or
cassette, start the correct machine, observe the result, inspect live 6809
state, and return to the same source workspace.

## The toolchain behind the experience

The visible menus sit on a substantial collection of maintained tools and
build scripts. These include lwtools/lwasm, asm6809, CMOC, ugBASIC,
BASIC-to-6809, mcbasic, ToolShed, 6801/6809 tools, bin2cas, cas2wav, disk and
cassette builders and extractors, emulator build scripts, and `m6809-gdb`.

CoCo-Pi also integrates pyDriveWire, DriveWire4, FujiNet-PC, and TNFS. A
project can run entirely in emulation or cross the boundary to a physical CoCo.
For example, the Launcher can build a DSK, upload it to a remote pyDriveWire
host, and mount it for an original machine without a shared filesystem.

The scale is larger than the headline list suggests. The current Installer
source payload inventories more than 180 build and source scripts, covering
assemblers, compilers, compression and filesystem utilities, operating-system
work, terminals, firmware and hardware tools, emulators, libraries,
demonstrations, and community software. Its curated shared-media payload
contains more than 10,000 entries. Together they preserve repeatable community
development knowledge as well as finished programs.

This is why CoCo-Pi is more than a software bundle. It preserves relationships
between tools: compiler output becomes vintage media; media enters the correct
machine; the machine can be observed and debugged; and the same project can
move from emulation to real hardware.

## The maintainer loop that keeps it coherent

```text
known-good live workstation -> selective harvest -> repository review
    -> curated Installer packages -> user deployment/update -> recorded fixes
```

Launcher harvest scripts collect the common layer, Linux scripts, Windows
PowerShell support, VS Code assets, MSYS2/Cygwin build recipes, and selected
Windows toolchains. Deployment uses checksums, dry runs, directory
synchronization, Git provenance, and a carefully last self-update. Installer
packaging selects CoCo-related assets while excluding unrelated collections,
transient emulator state, backups, and development metadata. Numbered,
idempotent fixes provide a safe Pi repair channel. This is release engineering
for a community retro-computing distribution.

## What can someone do with CoCo-Pi?

### Explore and preserve software

Use known machine configurations to run disk, tape, cartridge, and networked
software. Preserve not only files, but the information required to operate
them. Audit missing paths and update supported collections through maintained
utilities.

### Learn and teach

Experiment with BASIC, 6809 assembly, memory maps, video hardware, and vintage
storage formats using modern editing help and repeatable emulator states.

### Develop new CoCo software

Write in BASIC, assembly, C, ugBASIC, or translated BASIC; build media; launch
the target; debug the CPU; compare rendered behavior; and repeat.

### Work with original hardware

Use a CoCo-Pi system as a DriveWire or network-service host, build and mount
project disks remotely, and validate emulator-developed software on a physical
Color Computer.

### Investigate old programs

Combine source, map files, XRoar rendering, GDB memory inspection, snapshots,
and assisted observation to understand software whose original assumptions or
documentation may have been lost.

## One community platform

The Installer makes the system reproducible. The SD card makes it accessible
to Raspberry Pi users. The Launcher makes its breadth approachable. VS Code and
the toolchains support creation. XRoar supplies flexible emulation. XRoar AI
connects visible behavior with structured development evidence. DriveWire and
network services connect the modern host back to real CoCo hardware.

Together, these projects form a platform for enjoying the Color Computer's
past and building its future. The most important feature is not any single
emulator, compiler, menu, or AI tool. It is that all of them can participate in
one understandable workflow.

## Learn more

- [CoCo-Pi Project Overview](COCO_PI_PROJECT_OVERVIEW.md)
- [Debian 13 Installer Overview](DEBIAN13_INSTALLER_OVERVIEW.md)
- [Current Debian 13 installation instructions](README.md)
- CoCo-Pi Launcher: `mrgw454/CoCo-Pi-Launcher`
- XRoar AI: `mrgw454/xroar-ai`

Users interested in any individual component should also visit its upstream
project for authoritative documentation, credits, licenses, releases, and ways
to support its developers.
