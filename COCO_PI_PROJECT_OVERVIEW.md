# CoCo-Pi: A Complete Color Computer Workstation

## The CoCo environment, rebuilt for current systems

CoCo-Pi turns a modern Raspberry Pi—or a compatible Debian x86-64 computer—into
a dedicated environment for TRS-80 Color Computer, MC-10, and related 6809
systems. It combines emulators, development tools, disk and network services,
menus, documentation, and desktop integration in one maintained installation.

The current CoCo-Pi generation is maintained through the Installer's
`debian13` branch. The Installer can build the environment on Debian 13 across
Raspberry Pi and x86-64 systems, while Windows has grown close to Linux feature
parity through Python, PowerShell, MSYS2/MinGW, and Cygwin. From that maintained work, Ron also
produces a ready-to-use Raspberry Pi SD-card distribution for people who do not
want to perform the complete manual build themselves.

## Supported hosts

The Debian 13 work targets 64-bit Raspberry Pi systems, including Raspberry Pi
3 B+, 4, 400, 5, and 500, and Debian 13 on x86-64/amd64 computers. Windows
support covers most Launcher, emulator, toolchain, build-script, and VS Code
workflows, although a few gaps remain. The downloadable SD-card form remains
Raspberry Pi-only.

Rather than requiring every user to assemble a toolchain by hand, CoCo-Pi
installs and configures the pieces as a coordinated workstation:

- the CoCo-Pi Launcher and its structured software menus;
- CoCo, MC-10, and Dragon emulators;
- 6809 assemblers, compilers, disk utilities, and conversion tools;
- VS Code and CoCo-aware editor support;
- pyDriveWire and DriveWire-related workflows;
- FujiNet and network-service tooling where configured;
- shared media and emulator configuration; and
- maintenance scripts for later fixes and Launcher updates.

ROMs and other copyrighted machine firmware remain the user's responsibility.

## More capability than most people realize

CoCo-Pi is not one emulator and a menu of disk images. It is an integrated
toolbox whose components can be used together or independently:

- **Emulation:** XRoar, MAME, trs80gp, VCC, and OVCC cover CoCo, MC-10,
  Dragon, clones, and multiple host platforms.
- **Languages and toolchains:** lwtools/lwasm, asm6809, CMOC, ugBASIC,
  BASIC-to-6809, mcbasic, 6801/6809 tools, and BASIC renumbering support both
  vintage and cross-development workflows.
- **Media engineering:** ToolShed, disk and cassette builders/extractors,
  bin2cas, cas2wav, and MC-10 utilities create, inspect, and convert working
  media rather than merely launching downloads.
- **Original hardware:** pyDriveWire, DriveWire4, FujiNet-PC, and TNFS services
  connect the workstation to physical CoCos and network storage workflows.
- **Modern development:** VS Code extensions, hundreds of snippets, keyword
  and memory-map hovers, build tasks, workspace templates, `m6809-gdb`, and
  XRoar debugging connect source code to a live 6809 machine.
- **Software access and maintenance:** structured menus, attract mode,
  collection download/update tools, configuration audits, emulator version
  selection, and reproducible build scripts keep the environment useful over
  time.

This breadth is the real CoCo-Pi story: it can be a friendly software library,
a preservation station, a classroom, a cross-development machine, a service
host for real hardware, or all of those at once.

The current Installer payload makes that breadth measurable: more than 180
source/build scripts and over 10,000 curated shared-media entries preserve
repeatable ways to build tools and software as well as finished programs.

## Integration, not a claim of authorship

The emulators, assemblers, compilers, utilities, services, and libraries in
this ecosystem were created by many outstanding community and open-source
developers. Projects such as XRoar, MAME, ToolShed, lwtools/lwasm, CMOC,
ugBASIC, DriveWire, and FujiNet retain their own authors, licenses, and upstream
communities. CoCo-Pi should never obscure those contributions.

Ron's work is to discover and evaluate these projects, make them build and
coexist on supported hosts, preserve configuration and build knowledge,
connect them through Launcher and development workflows, package them for
others, and maintain the integration over time. The ecosystem is a showcase of
community achievement made practical as one workstation.

## XRoar: one flexible emulator across the family

XRoar is especially important within CoCo-Pi because it is not limited to one
model or one style of software. The same emulator can represent CoCo 1, CoCo 2,
CoCo 3, MC-10/Alice, and Dragon machines while handling cassette, disk,
cartridge, joystick, video, and expansion configurations appropriate to each.

For users, that means a consistent route into a large part of the 6809 home-
computer family. The Launcher supplies the machine-specific command line and
media setup; XRoar supplies the emulated hardware. A disk game, an MC-10 tape,
a Dragon program, and a CoCo 3 development build can all begin from the same
CoCo-Pi environment.

For developers, XRoar is equally flexible. It can be built from source by the
CoCo-Pi scripts, selected alongside other installed emulator versions, and
used with its GDB remote stub for live 6809 register and memory debugging from
VS Code.

An experimental Launcher branch is also integrating the opt-in XRoar AI build,
which can expose rendered-frame observation and controlled emulator operations
to development assistants. That work is deliberately separate from ordinary
XRoar and should be considered an emerging companion to the Debian 13 CoCo-Pi
environment, not a promise that every Debian 13 installation already contains
it.

## A system for using software and creating it

CoCo-Pi is designed for more than launching preserved programs. Its tools
support a complete development cycle:

```text
write -> assemble or compile -> build disk/cassette -> run in an emulator
      -> inspect or debug -> revise -> test on emulation or real hardware
```

VS Code integration provides CoCo and MC-10 BASIC highlighting, keyword and
memory-map help, hundreds of snippets, 6809/6309 instruction information, build
tasks, and workspace templates. The Launcher connects those editing tools to
the appropriate emulator, machine, media, and development utility.

Projects can also reach real Color Computers. pyDriveWire can run locally or
on a remote host connected to physical hardware. The Launcher can build a DSK,
upload it to the remote server, and mount it for the CoCo without requiring a
shared host filesystem. CoCo-Pi can therefore serve as both an emulation station
and a bridge to original machines.

## Two ways to receive the same maintained environment

The Debian 13 Installer makes the environment reproducible in stages. It sets
up the base files and desktop, installs the required packages and language
runtimes, builds the selected emulator and development packages, creates the
Launcher shortcut, and synchronizes the required VS Code extensions.

This manual-build model has several advantages:

- users begin with a current, recognizable Debian-based OS;
- build scripts document where important tools come from;
- Raspberry Pi and x86-64 systems can share much of the same environment;
- components can be repaired or updated without replacing an entire SD-card
  image; and
- CoCo-Pi remains understandable as a collection of maintained projects rather
  than an opaque appliance.

The Raspberry Pi SD-card distribution is the convenience alternative. Ron
builds it from the Installer-maintained work for people who want CoCo-Pi ready
to use without performing every installation and compilation stage. It is a
Pi-only delivery of the same larger project—not the source of truth for how the
environment is constructed. The `debian13` branch remains that maintained
foundation.

## A community platform

CoCo-Pi collects decades of Color Computer knowledge into a system people can
actually use: which emulator matches a machine, how media should be mounted,
which compiler targets are available, how a DriveWire service connects, and
how a project moves from source code to a running 6809 program.

It also maintains itself. Harvest scripts reconcile known-good Linux and
Windows workstations with the Launcher repository; deployment uses checksums,
dry runs, platform-aware synchronization, and Git provenance; Installer
packaging excludes unrelated and transient data; and numbered fixes safely
advance installed Pi systems.

That makes it valuable to several audiences:

- enthusiasts who want an organized way to explore CoCo software;
- developers who want a prepared native and cross-development environment;
- educators demonstrating BASIC, assembly language, and computer architecture;
- preservationists retaining the configuration needed to run software; and
- hardware users connecting modern storage and development tools to a real
  CoCo.

The Debian 13 port carries that idea forward on current Raspberry Pi hardware
and conventional PCs. Combined with the Launcher, VS Code integration, XRoar's
broad machine support, and emerging assisted-debugging tools, it provides a
strong foundation for both preserving the Color Computer's history and writing
its next software.

For the delivery and update system behind the current distribution, see
[DEBIAN13_INSTALLER_OVERVIEW.md](DEBIAN13_INSTALLER_OVERVIEW.md). For current
installation steps, prerequisites, and branch-specific cautions, see
[README.md](README.md).
