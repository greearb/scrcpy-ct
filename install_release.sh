#!/usr/bin/env bash
set -e

BUILDDIR=build-auto
PREBUILT_SERVER_URL=https://github.com/Genymobile/scrcpy/releases/download/v2.1/scrcpy-server-v2.1
PREBUILT_SERVER_SHA256=5b8bf1940264b930c71a1c614c57da2247f52b2d4240bca865cc6d366dff6688

echo "[scrcpy] Downloading prebuilt server..."
wget "$PREBUILT_SERVER_URL" -O scrcpy-server
echo "[scrcpy] Verifying prebuilt server..."
echo "$PREBUILT_SERVER_SHA256  scrcpy-server" | sha256sum --check

echo "[scrcpy] Building client..."
rm -rf "$BUILDDIR"

# Only set custom prefix if environment var defined
# and directory exists
MYPREFIX=
if [ ! -z "$CTPREFIX" ] && [ -d $CTPREFIX ]
then
	MYPREFIX=-Dprefix=$CTPREFIX
fi

set -x
meson setup "$BUILDDIR" --buildtype=release --strip -Db_lto=true \
    -Dprebuilt_server=scrcpy-server $MYPREFIX
cd "$BUILDDIR"
ninja

echo "[scrcpy] Installing (sudo)..."
sudo ninja install
