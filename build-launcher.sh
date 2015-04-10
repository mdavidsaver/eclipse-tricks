#!/bin/sh
set -e -x

[ -z "$JAVA_HOME" ] && export JAVA_HOME=/usr/lib/jvm/java-7-openjdk-amd64

ROOT=rt.equinox.framework/features/org.eclipse.equinox.executable.feature/library

rm -rf build-launcher
install -d build-launcher/gtk
install -d result-launcher

COM="$ROOT"

cp "$COM/make_version.mak" "$COM/"*.c "$COM/"*.h build-launcher/

COM="$ROOT/gtk"

cp "$COM/make_linux.mak" "$COM/"*.c "$COM/"*.h build-launcher/gtk/

cd build-launcher/gtk

make -f make_linux.mak

cp eclipse_*.so ../../result-launcher/
