#!/bin/bash -ex

wget -nv "http://download.microsoft.com/download/E/8/E/E8EEB394-7F42-4963-A2D8-29559B738298/VS2008ExpressWithSP1ENUX1504728.iso" -O /tmp/vs.iso
7z x /tmp/vs.iso -O/tmp VCExpress

xvfb-run -a wine /tmp/VCExpress/setup.exe /q /norestart

WIN_PATH_SRC=`wine cmd /c "echo %PATH%" | tr -d '\r\n' | sed 's/\\\\/\\\\\\\\\\\\\\\\/g'`
sed -i "s/%PATH%/${WIN_PATH_SRC}/g" /tmp/vs_vars.reg
wine regedit /S Z:\\tmp\\vs_vars.reg
wine cmd /c echo %PATH%
wineboot -s

rm -r /tmp/*

sleep 10
