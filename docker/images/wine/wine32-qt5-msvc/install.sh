#!/bin/bash -ex

INIT_REPO_ARGS=($QT5_INIT_REPO_ARGS)
USER_CONFIGURE_ARGS=($QT5_CONFIGURE_ARGS)
OPENSSL_ARGS=()
QT5_DIR="/opt/qt5"
QT5_DIR_WIN="Z:${QT5_DIR//\//\\\\}"

# Detect Visual Studio version
MSVC_VERSION=`wine nmake /? 2>&1 | grep Version | sed -r 's/^.*Version ([0-9]+).*$/\1/'`

case "$MSVC_VERSION" in
	8)  VS_VERSION=2005;;
	9)  VS_VERSION=2008;;
	10) VS_VERSION=2010;;
	11) VS_VERSION=2012;;
	12) VS_VERSION=2013;;
	14) VS_VERSION=2015;;
	*)
		echo "Unknown msvc version: '$MSVC_VERSION'" 1>&2
		exit -1
		;;
esac

QT5_BRANCH=master
if [ -n "$QT5_MINOR_VERSION" ]; then
	QT5_BRANCH=5.$QT5_MINOR_VERSION
fi

if [ "$QT5_NO_OPENSSL" != "true" ]; then
	OPENSSL_ARGS=(-openssl-linked -I Z:\\opt\\openssl\\include -L Z:\\opt\\openssl\\lib -l User32 -l Gdi32 OPENSSL_LIBS="-lssleay32 -llibeay32")
fi

CONFIGURE_ARGS=(-platform "win32-msvc$VS_VERSION" -opensource -confirm-license ${OPENSSL_ARGS[@]} ${USER_CONFIGURE_ARGS[@]})

WIN_PATH_SRC=`wine cmd /c "echo %PATH%" | tr -d '\r\n' | sed 's/\\\\/\\\\\\\\\\\\\\\\/g'`
REG_HEADER="Windows Registry Editor Version 5.00\r\n\r\n[HKEY_LOCAL_MACHINE\\\\SYSTEM\\\\CurrentControlSet\\\\Control\\\\Session Manager\\\\Environment]\r\n"

if [ "$QT5_NO_OPENSSL" != "true" ]; then
	# Clone and build openssl
	git clone --depth=1 -b OpenSSL_1_0_1-stable https://github.com/openssl/openssl.git /tmp/openssl
	wine cmd /c 'cd Z:\\tmp\\openssl && perl Configure VC-WIN32 --prefix=Z:\\opt\\openssl'
	wine cmd /c 'cd Z:\\tmp\\openssl && ms\\do_ms.bat'
	wine cmd /c 'cd Z:\\tmp\\openssl && nmake -f ms\\nt.mak install'
	rm -r /tmp/openssl
fi

# Clone Qt
git clone --depth=1 -b "$QT5_BRANCH" git://code.qt.io/qt/qt5.git "$QT5_DIR"
cd "$QT5_DIR"

if [ "$QT5_WITH_HTTP" == "true" ]; then
	git clone --depth=1 git://code.qt.io/qt/qthttp.git qthttp
	./qtbase/bin/syncqt.pl -version 5.1.0 qthttp
fi

# Init repository
./init-repository ${INIT_REPO_ARGS[@]}

# Use function-level linkning to minimize executable size
if [ "$QT5_FUNC_LEVEL_LINK" == "true" ]; then
	filename="qtbase/mkspecs/common/msvc-desktop.conf"
	if [ ! -f "$filename" ]; then
		filename="qtbase/mkspecs/win32-msvc$VS_VERSION/qmake.conf"
	fi
	sed -i 's/^QMAKE_CFLAGS\s*=.*$/\0 -Gy/g' "$filename"
fi

# Configure and build Qt
wine cmd /c configure ${CONFIGURE_ARGS[@]}
wine nmake

if [ "$QT5_WITH_HTTP" == "true" ]; then
	(cd qthttp && wine nmake install)
fi

# Add qt bin directory to PATH
echo -e "${REG_HEADER}\"PATH\"=\"${WIN_PATH_SRC};Z:${QT5_DIR//\//\\\\\\\\}\\\\\\\\qtbase\\\\\\\\bin\"\r\n" > /tmp/vars.reg
wine regedit /S Z:\\tmp\\vars.reg

# Apply changes
wineboot -s

rm -r /tmp/*
rm -r "$QT5_DIR/.git"

for module in `ls "$QT5_DIR"`; do
	gitdir="$QT5_DIR/${module}/.git"
	if [ -d "$gitdir" ]; then
		rm -r "$QT5_DIR/${module}/.git"
	fi
done

# Timeout for apply wine registry changes
sleep 10
