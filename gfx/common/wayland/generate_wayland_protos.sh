#!/bin/sh
WAYSCAN=/usr/bin/wayland-scanner
WAYSCAN_VER=$($WAYSCAN --version 2>&1 | awk '{print $2}')
WAYLAND_PROTOS=/usr/share/wayland-protocols
OUTPUT=gfx/common/wayland

if [ ! -d $WAYLAND_PROTOS ]; then
    WAYSCAN=/usr/local/bin/wayland-scanner
    WAYLAND_PROTOS=/usr/local/share/wayland-protocols
fi

if [ ! -d $OUTPUT ]; then
    mkdir $OUTPUT
fi

#Since Wayland 1.15 option "code" is deprecated. Recommended to use "private-code" option instead.
if [ "$WAYSCAN_VER -ge 1.15" ]; then
    CODEGEN=private-code
else
    CODEGEN=code
fi

#Generate xdg-shell_v6 header and .c files
$WAYSCAN client-header $WAYLAND_PROTOS/unstable/xdg-shell/xdg-shell-unstable-v6.xml $OUTPUT/xdg-shell-unstable-v6.h
$WAYSCAN $CODEGEN $WAYLAND_PROTOS/unstable/xdg-shell/xdg-shell-unstable-v6.xml $OUTPUT/xdg-shell-unstable-v6.c

#Generate xdg-shell header and .c files
$WAYSCAN client-header $WAYLAND_PROTOS/stable/xdg-shell/xdg-shell.xml $OUTPUT/xdg-shell.h
$WAYSCAN $CODEGEN $WAYLAND_PROTOS/stable/xdg-shell/xdg-shell.xml $OUTPUT/xdg-shell.c

#Generate idle-inhibit header and .c files
$WAYSCAN client-header $WAYLAND_PROTOS/unstable/idle-inhibit/idle-inhibit-unstable-v1.xml $OUTPUT/idle-inhibit-unstable-v1.h
$WAYSCAN $CODEGEN $WAYLAND_PROTOS/unstable/idle-inhibit/idle-inhibit-unstable-v1.xml $OUTPUT/idle-inhibit-unstable-v1.c

#Generate xdg-decoration header and .c files
$WAYSCAN client-header $WAYLAND_PROTOS/unstable/xdg-decoration/xdg-decoration-unstable-v1.xml $OUTPUT/xdg-decoration-unstable-v1.h
$WAYSCAN $CODEGEN $WAYLAND_PROTOS/unstable/xdg-decoration/xdg-decoration-unstable-v1.xml $OUTPUT/xdg-decoration-unstable-v1.c
