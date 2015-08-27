#!/bin/bash -ex

if [ -z "$QT_LINK_MODE" ]; then
	echo "QT_LINK_MODE not defined!" 1>&2
fi

WIN_PATH_SRC=`wine cmd /c "echo %PATH%" | tr -d '\r\n' | sed 's/\\\\/\\\\\\\\\\\\\\\\/g'`
REG_HEADER="Windows Registry Editor Version 5.00\r\n\r\n[HKEY_LOCAL_MACHINE\\\\SYSTEM\\\\CurrentControlSet\\\\Control\\\\Session Manager\\\\Environment]\r\n"

# Clone and build openssl
git clone --depth=1 -b OpenSSL_1_0_1-stable https://github.com/openssl/openssl.git /tmp/openssl
wine cmd /c 'cd Z:\\tmp\\openssl && perl Configure VC-WIN32 --prefix=Z:\\opt\\openssl'
wine cmd /c 'cd Z:\\tmp\\openssl && ms\\do_ms.bat'
wine cmd /c 'cd Z:\\tmp\\openssl && nmake -f ms\\nt.mak install'
rm -r /tmp/openssl

# Clone and patch Qt
git clone --depth=1 git://gitorious.org/qt/qt.git /opt/qt
rm -r /opt/qt/.git
patch -p1 -d /opt/qt < /tmp/posix_fix.patch
if [ "$QT_LINK_MODE" == "static" ]; then
	patch -p1 -d /opt/qt < /tmp/vs2010_func_level_linking.patch
done

# Configure and build Qt
wine cmd /c "cd /D Z:\\opt\\qt && configure.exe -arch windows -platform win32-msvc2010 -opensource -release -$QT_LINK_MODE -no-exceptions -no-qt3support -nomake examples -nomake demos -nomake tools -nomake translations -nomake docs -no-accessibility -no-libtiff -no-phonon -no-phonon-backend -no-multimedia -no-webkit -no-scripttools -no-declarative -confirm-license -I Z:\\opt\\openssl\\include -L Z:\\opt\\openssl\\lib -l libeay32 -l ssleay32"
wine cmd /c "cd /D Z:\\opt\\qt && nmake"

# Add qt bin directory to PATH
echo -e "${REG_HEADER}\"PATH\"=\"${WIN_PATH_SRC};Z:\\\\\\\\opt\\\\\\\\qt\\\\\\\\bin\"\r\n" > /tmp/vars.reg
wine regedit /S Z:\\tmp\\vars.reg

# Apply changes
wineboot -s

rm -r /tmp/*

# Timeout for apply wine registry changes
sleep 10
