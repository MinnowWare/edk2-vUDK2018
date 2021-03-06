@echo off
set path=%path%;"c:\NASM";%~dp0openssl-1.0.2r-x64_86-win64;%~dp0MinnowTools;C:\Program Files (x86)\DediProg\SF100;
set PYTHON_HOME=C:\Python27
if exist conf rd /s /q Conf

if not exist "C:\Program Files (x86)\Microsoft Visual Studio\2019\Community\VC\Auxiliary\Build\vcvars32.bat" (
	echo #####################################################################################
	echo ######################## Visual Studio 2019 is not installed ########################
	echo #####################################################################################
	ping -n 10 127.0.0.0 > NUL
	goto EOF
) else (
	call "C:\Program Files (x86)\Microsoft Visual Studio\2019\Community\VC\Auxiliary\Build\vcvars32.bat"
    %~d0
    cd %~p0MinnowTools
    rem ::::::::::::::::::::::::::::::::::::::::::::::::::::::
    rem ::: build all sources in the MinnowTools directory ::::
    rem ::::::::::::::::::::::::::::::::::::::::::::::::::::::
    echo ###################################################################################
    echo ###              build all sources in the MinnowTools directory                 ###
    echo ###################################################################################
    for %%c in (*.c) do cl /nologo %%c
    rem ping 127.0.0.0 > nul
    cd %~p0
	call edksetup.bat Rebuild
	call edksetup --nt32
)
%~d0
cd %~p0
rem echo %~dp0
rem :::::::::::::::::::::::::::::::::::::::::::::
rem ::: test GIT version ::::::::::::::::::::::::
rem :::::::::::::::::::::::::::::::::::::::::::::
gitverchk.exe -verbose
iaslverchk.exe -verbose
nasmverchk.exe -verbose
pyverchk.exe -verbose
set VSVERSION=2019
echo ###################################################################################
echo ###                                                                             ###
echo ###                             -=[ VS2019 ]=-                                  ###
echo ###                                                                             ###
echo ### To build the EmulationBuild (Nt32Pkg) for Release or Debug invoke:          ###
echo ###     bldREL.bat                                                              ###
echo ###        or                                                                   ###
echo ###     bldDEB.bat                                                              ###
echo ###                                                                             ###
echo ### enter "rd /s /q build" to clean previous build                              ###
echo ### enter "start DBG" to start the UEFI BIOS EMULATION                          ###
echo ###################################################################################
if not exist CdePkg\readme.md (
    echo ###################################################################################
    echo ###       SUBMODULES MISSING ### SUBMODULES MISSING ### SUBMODULES MISSING      ###
    echo ###################################################################################
    @echo Please run "git submodule update --init --recursive"
)
%COMSPEC% /k echo Welcome, to the jungle...
:EOF
