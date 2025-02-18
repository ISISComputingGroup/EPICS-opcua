@echo off
setlocal
set "PATH=%~dp0bin\%EPICS_HOST_ARCH%;%PATH%"
make
make runtests
