#!/bin/bash -ex

wget -nv "http://download.microsoft.com/download/1/E/5/1E5F1C0A-0D5B-426A-A603-1798B951DDAE/VS2010Express1.iso" -O /tmp/vs.iso
7z x /tmp/vs.iso -O/tmp VCExpress

xvfb-run -a wine /tmp/VCExpress/setup.exe /q /norestart

WIN_PATH_SRC=`wine cmd /c "echo %PATH%" | tr -d '\r\n' | sed 's/\\\\/\\\\\\\\\\\\\\\\/g'`
sed -i "s/%PATH%/${WIN_PATH_SRC}/g" /tmp/vs_vars.reg
wine regedit /S Z:\\tmp\\vs_vars.reg
wine cmd /c echo %PATH%
wineboot -s

rm -r /tmp/*

sleep 10
