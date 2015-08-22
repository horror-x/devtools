#!/bin/bash -ex

apt-get install -y ca-certificates

# Perl
wget -nv "http://downloads.activestate.com/ActivePerl/releases/5.22.0.2200/ActivePerl-5.22.0.2200-MSWin32-x86-64int-299195.msi" -O /tmp/perl.msi
wine msiexec /q /i Z:\\tmp\\perl.msi

# Python 2.7
wget -nv "https://www.python.org/ftp/python/2.7.8/python-2.7.10.msi" -O /tmp/python.msi
wine msiexec /q /i Z:\\tmp\\python.msi

# 7-Zip
wget -nv "http://sourceforge.net/projects/sevenzip/files/7-Zip/9.22/7z922.msi/download" -O /tmp/7z.msi
wine msiexec /q /i Z:\\tmp\\7z.msi

# Subversion
wget -nv "http://sourceforge.net/projects/win32svn/files/1.8.9/Setup-Subversion-1.8.9-1.msi/download" -O /tmp/svn.msi
wine msiexec /q /i Z:\\tmp\\svn.msi

# Git
wget -nv "https://github.com/msysgit/msysgit/releases/download/Git-1.9.5-preview20150319/Git-1.9.5-preview20150319.exe" -O /tmp/git.exe
xvfb-run -a wine /tmp/git.exe /VERYSILENT

# SConstruct
SCONS_VER=2.3.6
wget -nv "http://skylink.dl.sourceforge.net/project/scons/scons/2.3.6/scons-$SCONS_VER.zip" -O /tmp/scons-$SCONS_VER.zip
7z x /tmp/scons-$SCONS_VER.zip -o/tmp
wine cmd /c "C:\\Python27\\python.exe Z:\\tmp\\scons-$SCONS_VER\\setup.py install --install-bat"

# CMake
wget -nv http://www.cmake.org/files/v3.3/cmake-3.3.1-win32-x86.exe -O /tmp/cmake.exe
wine /tmp/cmake.exe /S

# Add tools to PATH
WIN_PATH_SRC=`wine cmd /c "echo %PATH%" | tr -d '\r\n' | sed 's/\\\\/\\\\\\\\\\\\\\\\/g'`
sed -i "s/%PATH%/${WIN_PATH_SRC}/g" /tmp/path.reg
wine regedit /S Z:\\tmp\\path.reg

# Apply changes
wineboot -s

# Remove temporary files
rm -r /tmp/*

# Timeout for apply wine registry changes
sleep 5
