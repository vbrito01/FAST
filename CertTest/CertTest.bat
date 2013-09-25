@ECHO OFF
@ECHO.


REM  Set up environment variables.  You will probably have to change these.


@SET Compare=FC /T
@SET CRUNCH=..\bin\crunch_win32.exe
rem @SET CRUNCH=Call Crunch

@SET MATLAB=matlab
@SET MBC_SOURCE=C:\Users\bjonkman\Documents\DATA\Downloads\MBC\Source
rem @SET MBC_SOURCE=C:\Users\bjonkman\Data\DesignCodes\MBC\Source
@SET DateTime=DateTime.exe
@SET Editor=NotePad.EXE

::=======================================================================================================
IF /I "%1"=="-DEBUG" GOTO debugVer
IF /I "%1"=="-GFORTRAN" GOTO gfortran
IF /I "%1"=="-IFORT" GOTO ifort
IF /I "%1"=="-DEVBUILD" GOTO devBuild
IF /I "%1"=="-DEVDEBUG" GOTO devDebugBuild

:releaseVer
echo Using released version of FAST (IVF/VS)
@SET FAST=..\bin\FAST_win32.exe
goto CertTest

:debugVer
echo Using FAST compiled in debug mode (IVF/VS)
@SET FAST=..\bin\FAST_debug_win32.exe
goto CertTest

:gfortran
echo Using FAST compiled with makefile (gfortran)
@SET FAST=..\compiling\FAST_gwin32.exe
goto CertTest

:ifort
echo Using FAST compiled with Compile_FAST.bat (IVF)
@SET FAST=..\compiling\FAST_iwin32.exe
goto CertTest

:devBuild
echo Using FAST compiled with Visual Studio Project, release mode (IVF/VS)
@SET FAST=..\compiling\FAST_win32.exe
goto CertTest

:devDebugBuild
echo Using FAST compiled with Visual Studio Project, debug mode (IVF/VS)
@SET FAST=..\compiling\FAST_debug_win32.exe
goto CertTest

::=======================================================================================================


:CertTest

REM  FAST test sequence definition:

@SET  TEST01=Test #01: AWT-27CR2 with many DOFs with fixed yaw error and steady wind.  AA plots.
@SET  TEST02=Test #02: AWT-27CR2 with many DOFs with startup and shutdown and steady wind.  Time plots.
@SET  TEST03=Test #03: AWT-27CR2 with many DOFs with free yaw and steady wind.  AA plots.
@SET  TEST04=Test #04: AWT-27CR2 with many DOFs with free yaw and FF turbulence.  PMF plots.
@SET  TEST05=Test #05: AWT-27CR2 with many DOFs with startup and shutdown and FF turbulence.  Time plots.
@SET  TEST06=Test #06: AOC 15/50 with many DOFs with gen start loss of grid and tip-brake shutdown.  Time plots.
@SET  TEST07=Test #07: AOC 15/50 with many DOFs with free yaw and FF turbulence.  PMF plots.
@SET  TEST08=Test #08: AOC 15/50 with many DOFs with fixed yaw error and steady wind.  AA plots.
@SET  TEST09=Test #09: UAE Phase VI (downwind) with many DOFs with yaw ramp and a steady wind.  Time plots.
@SET  TEST10=Test #10: UAE Phase VI (upwind) with no DOFs in a ramped wind.  Time plots.
@SET  TEST11=Test #11: WindPACT 1.5 MW Baseline with many DOFs undergoing a pitch failure.  Time plots.
@SET  TEST12=Test #12: WindPACT 1.5 MW Baseline with many DOFs with VS and VP and ECD wind.  Time plots.
@SET  TEST13=Test #13: WindPACT 1.5 MW Baseline with many DOFs with VS and VP and FF turbulence.  PMF plots.
@SET  TEST14=Test #14: WindPACT 1.5 MW Baseline with many DOFs and system linearization.  Column chart.
@SET  TEST15=Test #15: SWRT with many DOFs with free yaw tail-furl and VS and EOG wind.  Time plots.
@SET  TEST16=Test #16: SWRT with many DOFs with free yaw tail-furl and VS and EDC wind.  Time plots.
@SET  TEST17=Test #17: SWRT with many DOFs with free yaw tail-furl and VS and FF turbulence.  PMF plots.
@SET  TEST18=Test #18: NREL 5 MW Baseline Onshore Turbine
@SET  TEST19=Test #19: NREL 5 MW Baseline Offshore Turbine with Monopile RF
@SET  TEST20=Test #20: NREL 5 MW Baseline Offshore Turbine with ITI Barge
@SET  TEST21=Test #21: NREL 5 MW Baseline Offshore Turbine with Floating TLP
@SET  TEST22=Test #22: NREL 5 MW Baseline Offshore Turbine with OC3 Hywind modifications

@SET  DASHES=---------------------------------------------------------------------------------------------
@SET  POUNDS=#############################################################################################

@IF EXIST CertTest.out  DEL CertTest.out

ECHO.                                               >> CertTest.out
ECHO           ************************************ >> CertTest.out
ECHO           **  FAST Acceptance Test Results  ** >> CertTest.out
ECHO           ************************************ >> CertTest.out

ECHO.                                                                             >> CertTest.out
ECHO ############################################################################ >> CertTest.out
ECHO # Inspect this file for any differences between your results and the saved # >> CertTest.out
ECHO # results.  Any differing lines and the two lines surrounding them will be # >> CertTest.out
ECHO # listed.  The only differences should be the time stamps at the start of  # >> CertTest.out
ECHO # each file.                                                               # >> CertTest.out
ECHO #                                                                          # >> CertTest.out
ECHO # If you are running on something other than a PC, you may see differences # >> CertTest.out
ECHO # in the last significant digit of many of the numbers.                    # >> CertTest.out
ECHO ############################################################################ >> CertTest.out

ECHO.                                            >> CertTest.out
ECHO Date and time this acceptance test was run: >> CertTest.out
%DateTime%                                       >> CertTest.out
ECHO.                                            >> CertTest.out


rem *******************************************************

@echo FAST %TEST01%

@SET TEST=01

rem Run FAST.

%FAST% Test%TEST%.fst

IF ERRORLEVEL 1  GOTO ERROR

@IF NOT EXIST Test%TEST%.out  GOTO ERROR

rem Crunch the FAST output.
%CRUNCH% Test%TEST%.cru

IF ERRORLEVEL 1  GOTO ERROR

@IF NOT EXIST Test%TEST%.sts  GOTO ERROR

echo.                                            >> CertTest.out
echo %POUNDS%                                    >> CertTest.out
echo.                                            >> CertTest.out
echo %TEST01%                                    >> CertTest.out
echo %DASHES%                                    >> CertTest.out
%Compare% Test%TEST%.sts TstFiles\Test%TEST%.sts >> CertTest.out
echo %DASHES%                                    >> CertTest.out
%Compare% Test%TEST%.azi TstFiles\Test%TEST%.azi >> CertTest.out
echo %DASHES%                                    >> CertTest.out
%Compare% Test%TEST%_ElastoDyn.sum TstFiles\Test%TEST%_ElastoDyn.sum >> CertTest.out
echo %DASHES%                                    >> CertTest.out
%Compare% Test%TEST%.opt TstFiles\Test%TEST%.opt >> CertTest.out


rem *******************************************************

@echo FAST %TEST02%

@SET TEST=02

rem Run FAST.

%FAST% Test%TEST%.fst

IF ERRORLEVEL 1  GOTO ERROR

@IF NOT EXIST Test%TEST%.out   GOTO ERROR
@IF NOT EXIST Test%TEST%.outb  GOTO ERROR

rem Crunch the FAST output.
%CRUNCH% Test%TEST%.cru

IF ERRORLEVEL 1  GOTO ERROR

@IF NOT EXIST Test%TEST%.sts  GOTO ERROR

echo.                                            >> CertTest.out
echo %POUNDS%                                    >> CertTest.out
echo.                                            >> CertTest.out
echo %TEST02%                                    >> CertTest.out
echo %DASHES%                                    >> CertTest.out
%Compare% Test%TEST%.sts TstFiles\Test%TEST%.sts >> CertTest.out
echo %DASHES%                                    >> CertTest.out
%Compare% Test%TEST%_ElastoDyn.sum TstFiles\Test%TEST%_ElastoDyn.sum >> CertTest.out
echo %DASHES%                                    >> CertTest.out
%Compare% Test%TEST%.opt TstFiles\Test%TEST%.opt >> CertTest.out


rem *******************************************************

@echo FAST %TEST03%

@SET TEST=03

rem Run FAST.

%FAST% Test%TEST%.fst

IF ERRORLEVEL 1  GOTO ERROR

@IF NOT EXIST Test%TEST%.out  GOTO ERROR

rem Crunch the FAST output.
%CRUNCH% Test%TEST%.cru

IF ERRORLEVEL 1  GOTO ERROR

@IF NOT EXIST Test%TEST%.sts  GOTO ERROR

echo.                                            >> CertTest.out
echo %POUNDS%                                    >> CertTest.out
echo.                                            >> CertTest.out
echo %TEST03%                                    >> CertTest.out
echo %DASHES%                                    >> CertTest.out
%Compare% Test%TEST%.sts TstFiles\Test%TEST%.sts >> CertTest.out
echo %DASHES%                                    >> CertTest.out
%Compare% Test%TEST%.azi TstFiles\Test%TEST%.azi >> CertTest.out
echo %DASHES%                                    >> CertTest.out
%Compare% Test%TEST%_ElastoDyn.sum TstFiles\Test%TEST%_ElastoDyn.sum >> CertTest.out
echo %DASHES%                                    >> CertTest.out
%Compare% Test%TEST%.opt TstFiles\Test%TEST%.opt >> CertTest.out


rem *******************************************************

@echo FAST %TEST04%

@SET TEST=04

rem Run FAST.

%FAST% Test%TEST%.fst

IF ERRORLEVEL 1  GOTO ERROR

@IF NOT EXIST Test%TEST%.outb  GOTO ERROR

rem Crunch the FAST output.
%CRUNCH% Test%TEST%.cru

IF ERRORLEVEL 1  GOTO ERROR

@IF NOT EXIST Test%TEST%.sts  GOTO ERROR

echo.                                            >> CertTest.out
echo %POUNDS%                                    >> CertTest.out
echo.                                            >> CertTest.out
echo %TEST04%                                    >> CertTest.out
echo %DASHES%                                    >> CertTest.out
%Compare% Test%TEST%.sts TstFiles\Test%TEST%.sts >> CertTest.out
echo %DASHES%                                    >> CertTest.out
%Compare% Test%TEST%.pmf TstFiles\Test%TEST%.pmf >> CertTest.out
echo %DASHES%                                    >> CertTest.out
%Compare% Test%TEST%_ElastoDyn.sum TstFiles\Test%TEST%_ElastoDyn.sum >> CertTest.out
echo %DASHES%                                    >> CertTest.out
%Compare% Test%TEST%.opt TstFiles\Test%TEST%.opt >> CertTest.out


rem *******************************************************

@echo FAST %TEST05%

@SET TEST=05

rem Run FAST.

%FAST% Test%TEST%.fst

IF ERRORLEVEL 1  GOTO ERROR

@IF NOT EXIST Test%TEST%.out  GOTO ERROR

rem Crunch the FAST output.
%CRUNCH% Test%TEST%.cru

IF ERRORLEVEL 1  GOTO ERROR

@IF NOT EXIST Test%TEST%.sts  GOTO ERROR

echo.                                            >> CertTest.out
echo %POUNDS%                                    >> CertTest.out
echo.                                            >> CertTest.out
echo %TEST05%                                    >> CertTest.out
echo %DASHES%                                    >> CertTest.out
%Compare% Test%TEST%.sts TstFiles\Test%TEST%.sts >> CertTest.out
echo %DASHES%                                    >> CertTest.out
%Compare% Test%TEST%_ElastoDyn.sum TstFiles\Test%TEST%_ElastoDyn.sum >> CertTest.out
echo %DASHES%                                    >> CertTest.out
%Compare% Test%TEST%.opt TstFiles\Test%TEST%.opt >> CertTest.out


rem *******************************************************

@echo FAST %TEST06%

@SET TEST=06

rem Run FAST.

%FAST% Test%TEST%.fst

IF ERRORLEVEL 1  GOTO ERROR

@IF NOT EXIST Test%TEST%.out  GOTO ERROR

rem Crunch the FAST output.
%CRUNCH% Test%TEST%.cru

IF ERRORLEVEL 1  GOTO ERROR

@IF NOT EXIST Test%TEST%.sts  GOTO ERROR

echo.                                            >> CertTest.out
echo %POUNDS%                                    >> CertTest.out
echo.                                            >> CertTest.out
echo %TEST06%                                    >> CertTest.out
echo %DASHES%                                    >> CertTest.out
%Compare% Test%TEST%.sts TstFiles\Test%TEST%.sts >> CertTest.out
echo %DASHES%                                    >> CertTest.out
%Compare% Test%TEST%_ElastoDyn.sum TstFiles\Test%TEST%_ElastoDyn.sum >> CertTest.out
echo %DASHES%                                    >> CertTest.out
%Compare% Test%TEST%.opt TstFiles\Test%TEST%.opt >> CertTest.out


rem *******************************************************

@echo FAST %TEST07%

@SET TEST=07

rem Run FAST.

%FAST% Test%TEST%.fst

IF ERRORLEVEL 1  GOTO ERROR

@IF NOT EXIST Test%TEST%.out  GOTO ERROR

rem Crunch the FAST output.
%CRUNCH% Test%TEST%.cru

IF ERRORLEVEL 1  GOTO ERROR

@IF NOT EXIST Test%TEST%.sts  GOTO ERROR

echo.                                            >> CertTest.out
echo %POUNDS%                                    >> CertTest.out
echo.                                            >> CertTest.out
echo %TEST07%                                    >> CertTest.out
echo %DASHES%                                    >> CertTest.out
%Compare% Test%TEST%.sts TstFiles\Test%TEST%.sts >> CertTest.out
echo %DASHES%                                    >> CertTest.out
%Compare% Test%TEST%.pmf TstFiles\Test%TEST%.pmf >> CertTest.out
echo %DASHES%                                    >> CertTest.out
%Compare% Test%TEST%_ElastoDyn.sum TstFiles\Test%TEST%_ElastoDyn.sum >> CertTest.out
echo %DASHES%                                    >> CertTest.out
%Compare% Test%TEST%.opt TstFiles\Test%TEST%.opt >> CertTest.out


rem *******************************************************

@echo FAST %TEST08%

@SET TEST=08

rem Run FAST.

%FAST% Test%TEST%.fst

IF ERRORLEVEL 1  GOTO ERROR

@IF NOT EXIST Test%TEST%.out  GOTO ERROR

rem Crunch the FAST output.
%CRUNCH% Test%TEST%.cru

IF ERRORLEVEL 1  GOTO ERROR

@IF NOT EXIST Test%TEST%.sts  GOTO ERROR

echo.                                            >> CertTest.out
echo %POUNDS%                                    >> CertTest.out
echo.                                            >> CertTest.out
echo %TEST08%                                    >> CertTest.out
echo %DASHES%                                    >> CertTest.out
%Compare% Test%TEST%.sts TstFiles\Test%TEST%.sts >> CertTest.out
echo %DASHES%                                    >> CertTest.out
%Compare% Test%TEST%.azi TstFiles\Test%TEST%.azi >> CertTest.out
echo %DASHES%                                    >> CertTest.out
%Compare% Test%TEST%_ElastoDyn.sum TstFiles\Test%TEST%_ElastoDyn.sum >> CertTest.out
echo %DASHES%                                    >> CertTest.out
%Compare% Test%TEST%.opt TstFiles\Test%TEST%.opt >> CertTest.out


rem *******************************************************

@echo FAST %TEST09%

@SET TEST=09

rem Run FAST.

%FAST% Test%TEST%.fst

IF ERRORLEVEL 1  GOTO ERROR

@IF NOT EXIST Test%TEST%.out  GOTO ERROR

rem Crunch the FAST output.
%CRUNCH% Test%TEST%.cru

IF ERRORLEVEL 1  GOTO ERROR

@IF NOT EXIST Test%TEST%.sts  GOTO ERROR

echo.                                            >> CertTest.out
echo %POUNDS%                                    >> CertTest.out
echo.                                            >> CertTest.out
echo %TEST09%                                    >> CertTest.out
echo %DASHES%                                    >> CertTest.out
%Compare% Test%TEST%.sts TstFiles\Test%TEST%.sts >> CertTest.out
echo %DASHES%                                    >> CertTest.out
%Compare% Test%TEST%_ElastoDyn.sum TstFiles\Test%TEST%_ElastoDyn.sum >> CertTest.out
echo %DASHES%                                    >> CertTest.out
%Compare% Test%TEST%.opt TstFiles\Test%TEST%.opt >> CertTest.out


rem *******************************************************

@echo FAST %TEST10%

@SET TEST=10

rem Run FAST.

%FAST% Test%TEST%.fst

IF ERRORLEVEL 1  GOTO ERROR

@IF NOT EXIST Test%TEST%.out  GOTO ERROR

rem Crunch the FAST output.
%CRUNCH% Test%TEST%.cru

IF ERRORLEVEL 1  GOTO ERROR

@IF NOT EXIST Test%TEST%.sts  GOTO ERROR

echo.                                            >> CertTest.out
echo %POUNDS%                                    >> CertTest.out
echo.                                            >> CertTest.out
echo %TEST10%                                    >> CertTest.out
echo %DASHES%                                    >> CertTest.out
%Compare% Test%TEST%.sts TstFiles\Test%TEST%.sts >> CertTest.out
echo %DASHES%                                    >> CertTest.out
%Compare% Test%TEST%_ElastoDyn.sum TstFiles\Test%TEST%_ElastoDyn.sum >> CertTest.out
echo %DASHES%                                    >> CertTest.out
%Compare% Test%TEST%.opt TstFiles\Test%TEST%.opt >> CertTest.out


rem *******************************************************

@echo FAST %TEST11%

@SET TEST=11

rem Run FAST.

%FAST% Test%TEST%.fst

IF ERRORLEVEL 1  GOTO ERROR

@IF NOT EXIST Test%TEST%.out  GOTO ERROR

rem Crunch the FAST output.
%CRUNCH% Test%TEST%.cru

IF ERRORLEVEL 1  GOTO ERROR

@IF NOT EXIST Test%TEST%.sts  GOTO ERROR

echo.                                            >> CertTest.out
echo %POUNDS%                                    >> CertTest.out
echo.                                            >> CertTest.out
echo %TEST11%                                    >> CertTest.out
echo %DASHES%                                    >> CertTest.out
%Compare% Test%TEST%.sts TstFiles\Test%TEST%.sts >> CertTest.out
echo %DASHES%                                    >> CertTest.out
%Compare% Test%TEST%_ElastoDyn.sum TstFiles\Test%TEST%_ElastoDyn.sum >> CertTest.out
echo %DASHES%                                    >> CertTest.out
%Compare% Test%TEST%.opt TstFiles\Test%TEST%.opt >> CertTest.out


rem *******************************************************

@echo FAST %TEST12%

@SET TEST=12

rem Run FAST.

%FAST% Test%TEST%.fst

IF ERRORLEVEL 1  GOTO ERROR

@IF NOT EXIST Test%TEST%.out  GOTO ERROR

rem Crunch the FAST output.
%CRUNCH% Test%TEST%.cru

IF ERRORLEVEL 1  GOTO ERROR

@IF NOT EXIST Test%TEST%.sts  GOTO ERROR

echo.                                            >> CertTest.out
echo %POUNDS%                                    >> CertTest.out
echo.                                            >> CertTest.out
echo %TEST12%                                    >> CertTest.out
echo %DASHES%                                    >> CertTest.out
%Compare% Test%TEST%.sts TstFiles\Test%TEST%.sts >> CertTest.out
echo %DASHES%                                    >> CertTest.out
%Compare% Test%TEST%_ElastoDyn.sum TstFiles\Test%TEST%_ElastoDyn.sum >> CertTest.out
echo %DASHES%                                    >> CertTest.out
%Compare% Test%TEST%.opt TstFiles\Test%TEST%.opt >> CertTest.out


rem *******************************************************

@echo FAST %TEST13%

@SET TEST=13

rem Run FAST.

%FAST% Test%TEST%.fst

IF ERRORLEVEL 1  GOTO ERROR

@IF NOT EXIST Test%TEST%.out  GOTO ERROR

rem Crunch the FAST output.
%CRUNCH% Test%TEST%.cru

IF ERRORLEVEL 1  GOTO ERROR

@IF NOT EXIST Test%TEST%.sts  GOTO ERROR

echo.                                            >> CertTest.out
echo %POUNDS%                                    >> CertTest.out
echo.                                            >> CertTest.out
echo %TEST13%                                    >> CertTest.out
echo %DASHES%                                    >> CertTest.out
%Compare% Test%TEST%.sts TstFiles\Test%TEST%.sts >> CertTest.out
echo %DASHES%                                    >> CertTest.out
%Compare% Test%TEST%.pmf TstFiles\Test%TEST%.pmf >> CertTest.out
echo %DASHES%                                    >> CertTest.out
%Compare% Test%TEST%_ElastoDyn.sum TstFiles\Test%TEST%_ElastoDyn.sum >> CertTest.out
echo %DASHES%                                    >> CertTest.out
%Compare% Test%TEST%.opt TstFiles\Test%TEST%.opt >> CertTest.out


rem *******************************************************
:Test14
@echo FAST %TEST14%

@SET TEST=14

echo %POUNDS%
@echo Skipping this test until linearization is included.
echo %POUNDS%
GOTO Test15

rem Run FAST.

rem %FAST% Test%TEST%.fst

IF ERRORLEVEL 1  GOTO ERROR

@IF NOT EXIST Test%TEST%.lin  GOTO ERROR

Perform an eigenanalysis in MATLAB:
echo. Running Matlab to calculate eigenvalues. If an error occurs, close Matlab to continue CertTest....
%MATLAB% /wait /r addpath('%MBC_SOURCE%');Test%TEST% /logfile Test%TEST%.eig

@rem echo. Call to Matlab completed.

IF ERRORLEVEL 1  GOTO MATLABERROR

@IF NOT EXIST Test%TEST%.eig  GOTO MATLABERROR

echo.                                            >> CertTest.out
echo %POUNDS%                                    >> CertTest.out
echo.                                            >> CertTest.out
echo %TEST14%                                    >> CertTest.out
echo %DASHES%                                    >> CertTest.out
%Compare% Test%TEST%.eig TstFiles\Test%TEST%.eig >> CertTest.out
echo %DASHES%                                    >> CertTest.out
%Compare% Test%TEST%.sum TstFiles\Test%TEST%.sum >> CertTest.out


rem *******************************************************
:Test15
:MATLABERROR
@echo FAST %TEST15%

@SET TEST=15

rem Run FAST.

%FAST% Test%TEST%.fst

IF ERRORLEVEL 1  GOTO ERROR

@IF NOT EXIST Test%TEST%.out  GOTO ERROR

rem Crunch the FAST output.
%CRUNCH% Test%TEST%.cru

IF ERRORLEVEL 1  GOTO ERROR

@IF NOT EXIST Test%TEST%.sts  GOTO ERROR

echo.                                            >> CertTest.out
echo %POUNDS%                                    >> CertTest.out
echo.                                            >> CertTest.out
echo %TEST15%                                    >> CertTest.out
echo %DASHES%                                    >> CertTest.out
%Compare% Test%TEST%.sts TstFiles\Test%TEST%.sts >> CertTest.out
echo %DASHES%                                    >> CertTest.out
%Compare% Test%TEST%_ElastoDyn.sum TstFiles\Test%TEST%_ElastoDyn.sum >> CertTest.out
echo %DASHES%                                    >> CertTest.out
%Compare% Test%TEST%.opt TstFiles\Test%TEST%.opt >> CertTest.out


rem *******************************************************
:Test16
@echo FAST %TEST16%

@SET TEST=16

rem Run FAST.

%FAST% Test%TEST%.fst

IF ERRORLEVEL 1  GOTO ERROR

@IF NOT EXIST Test%TEST%.out  GOTO ERROR

rem Crunch the FAST output.
%CRUNCH% Test%TEST%.cru

IF ERRORLEVEL 1  GOTO ERROR

@IF NOT EXIST Test%TEST%.sts  GOTO ERROR

echo.                                            >> CertTest.out
echo %POUNDS%                                    >> CertTest.out
echo.                                            >> CertTest.out
echo %TEST16%                                    >> CertTest.out
echo %DASHES%                                    >> CertTest.out
%Compare% Test%TEST%.sts TstFiles\Test%TEST%.sts >> CertTest.out
echo %DASHES%                                    >> CertTest.out
%Compare% Test%TEST%_ElastoDyn.sum TstFiles\Test%TEST%_ElastoDyn.sum >> CertTest.out
echo %DASHES%                                    >> CertTest.out
%Compare% Test%TEST%.opt TstFiles\Test%TEST%.opt >> CertTest.out


rem *******************************************************
:Test17
@echo FAST %TEST17%

@SET TEST=17

rem Run FAST.

%FAST% Test%TEST%.fst

IF ERRORLEVEL 1  GOTO ERROR

@IF NOT EXIST Test%TEST%.out  GOTO ERROR

rem Crunch the FAST output.
%CRUNCH% Test%TEST%.cru

IF ERRORLEVEL 1  GOTO ERROR

@IF NOT EXIST Test%TEST%.sts  GOTO ERROR

echo.                                            >> CertTest.out
echo %POUNDS%                                    >> CertTest.out
echo.                                            >> CertTest.out
echo %TEST17%                                    >> CertTest.out
echo %DASHES%                                    >> CertTest.out
%Compare% Test%TEST%.sts TstFiles\Test%TEST%.sts >> CertTest.out
echo %DASHES%                                    >> CertTest.out
%Compare% Test%TEST%.pmf TstFiles\Test%TEST%.pmf >> CertTest.out
echo %DASHES%                                    >> CertTest.out
%Compare% Test%TEST%_ElastoDyn.sum TstFiles\Test%TEST%_ElastoDyn.sum >> CertTest.out
echo %DASHES%                                    >> CertTest.out
%Compare% Test%TEST%.opt TstFiles\Test%TEST%.opt >> CertTest.out



rem *******************************************************
:Test18
@echo FAST %TEST18%

@SET TEST=18

rem Run FAST.

%FAST% Test%TEST%.fst

IF ERRORLEVEL 1  GOTO ERROR

@IF NOT EXIST Test%TEST%.outb  GOTO ERROR

rem Crunch the FAST output.
%CRUNCH% Test%TEST%.cru

IF ERRORLEVEL 1  GOTO ERROR

@IF NOT EXIST Test%TEST%.sts  GOTO ERROR

echo.                                            >> CertTest.out
echo %POUNDS%                                    >> CertTest.out
echo.                                            >> CertTest.out
echo %TEST18%                                    >> CertTest.out
echo %DASHES%                                    >> CertTest.out
%Compare% Test%TEST%.sts TstFiles\Test%TEST%.sts >> CertTest.out
echo %DASHES%                                    >> CertTest.out
%Compare% Test%TEST%.sum TstFiles\Test%TEST%.sum >> CertTest.out
echo %DASHES%                                    >> CertTest.out
%Compare% Test%TEST%.opt TstFiles\Test%TEST%.opt >> CertTest.out




rem *******************************************************
:Test19
@echo FAST %TEST19%

echo %POUNDS%
@echo Skipping this test until SubDyn and MAP are included
echo %POUNDS%
GOTO Test20

@SET TEST=19

rem Run FAST.

%FAST% Test%TEST%.fst

IF ERRORLEVEL 1  GOTO ERROR

@IF NOT EXIST Test%TEST%.outb  GOTO ERROR

rem Crunch the FAST output.
%CRUNCH% Test%TEST%.cru

IF ERRORLEVEL 1  GOTO ERROR

@IF NOT EXIST Test%TEST%.sts  GOTO ERROR

echo.                                            >> CertTest.out
echo %POUNDS%                                    >> CertTest.out
echo.                                            >> CertTest.out
echo %TEST19%                                    >> CertTest.out
echo %DASHES%                                    >> CertTest.out
%Compare% Test%TEST%.sts TstFiles\Test%TEST%.sts >> CertTest.out
echo %DASHES%                                    >> CertTest.out
%Compare% Test%TEST%.sum TstFiles\Test%TEST%.sum >> CertTest.out
echo %DASHES%                                    >> CertTest.out
%Compare% Test%TEST%.opt TstFiles\Test%TEST%.opt >> CertTest.out



rem *******************************************************
:Test20
@echo FAST %TEST20%

@SET TEST=20

rem Run FAST.

%FAST% Test%TEST%.fst

IF ERRORLEVEL 1  GOTO ERROR

@IF NOT EXIST Test%TEST%.outb  GOTO ERROR

rem Crunch the FAST output.
%CRUNCH% Test%TEST%.cru

IF ERRORLEVEL 1  GOTO ERROR

@IF NOT EXIST Test%TEST%.sts  GOTO ERROR

echo.                                            >> CertTest.out
echo %POUNDS%                                    >> CertTest.out
echo.                                            >> CertTest.out
echo %TEST20%                                    >> CertTest.out
echo %DASHES%                                    >> CertTest.out
%Compare% Test%TEST%.sts TstFiles\Test%TEST%.sts >> CertTest.out
echo %DASHES%                                    >> CertTest.out
%Compare% Test%TEST%.sum TstFiles\Test%TEST%.sum >> CertTest.out
echo %DASHES%                                    >> CertTest.out
%Compare% Test%TEST%.opt TstFiles\Test%TEST%.opt >> CertTest.out



rem *******************************************************
:Test21
@echo FAST %TEST21%

@SET TEST=21

rem Run FAST.

%FAST% Test%TEST%.fst

IF ERRORLEVEL 1  GOTO ERROR

@IF NOT EXIST Test%TEST%.outb  GOTO ERROR

rem Crunch the FAST output.
%CRUNCH% Test%TEST%.cru

IF ERRORLEVEL 1  GOTO ERROR

@IF NOT EXIST Test%TEST%.sts  GOTO ERROR

echo.                                            >> CertTest.out
echo %POUNDS%                                    >> CertTest.out
echo.                                            >> CertTest.out
echo %TEST21%                                    >> CertTest.out
echo %DASHES%                                    >> CertTest.out
%Compare% Test%TEST%.sts TstFiles\Test%TEST%.sts >> CertTest.out
echo %DASHES%                                    >> CertTest.out
%Compare% Test%TEST%.sum TstFiles\Test%TEST%.sum >> CertTest.out
echo %DASHES%                                    >> CertTest.out
%Compare% Test%TEST%.opt TstFiles\Test%TEST%.opt >> CertTest.out




rem *******************************************************
:Test22
@echo FAST %TEST22%

@SET TEST=22

rem Run FAST.

%FAST% Test%TEST%.fst

IF ERRORLEVEL 1  GOTO ERROR

@IF NOT EXIST Test%TEST%.outb  GOTO ERROR

rem Crunch the FAST output.
%CRUNCH% Test%TEST%.cru

IF ERRORLEVEL 1  GOTO ERROR

@IF NOT EXIST Test%TEST%.sts  GOTO ERROR

echo.                                            >> CertTest.out
echo %POUNDS%                                    >> CertTest.out
echo.                                            >> CertTest.out
echo %TEST22%                                    >> CertTest.out
echo %DASHES%                                    >> CertTest.out
%Compare% Test%TEST%.sts TstFiles\Test%TEST%.sts >> CertTest.out
echo %DASHES%                                    >> CertTest.out
%Compare% Test%TEST%.sum TstFiles\Test%TEST%.sum >> CertTest.out
echo %DASHES%                                    >> CertTest.out
%Compare% Test%TEST%.opt TstFiles\Test%TEST%.opt >> CertTest.out



rem ******************************************************
rem  Let's look at the comparisons.
:Comparisons

rem %MATLAB% /r PlotCertTestResults('.','.\TstFiles');exit;


%Editor% CertTest.out
goto END

:ERROR
@echo ** An error has occurred in Test #%TEST% **

:END

@SET CRUNCH=
@SET MATLAB=
@SET MBC_SOURCE=
@SET Compare=
@SET DASHES=
@SET DateTime=
@SET Editor=
@SET FAST=
@SET POUNDS=
@SET TEST=
@SET TEST01=
@SET TEST02=
@SET TEST03=
@SET TEST04=
@SET TEST05=
@SET TEST06=
@SET TEST07=
@SET TEST08=
@SET TEST09=
@SET TEST10=
@SET TEST11=
@SET TEST12=
@SET TEST13=
@SET TEST14=
@SET TEST15=
@SET TEST16=
@SET TEST17=
@SET TEST18=
@SET TEST19=
@SET TEST20=
@SET TEST21=
@SET TEST22=

type Bell.txt
@echo Processing complete.
