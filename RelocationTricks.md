# Introduction #

Technically, Qt does not support building their Qt libraries in one location and installing them to another. This installer does allows you to pick where you install the Qt libraries and I have done quite a few nuanced tricks to make it work.

As far as I can tell, the installer produces a fully functioning Qt build that builds every complex Qt project I have thrown at it, but because of the unsupported nature of the build/relocate setup, you may run into obscure issues. Feel free to create tickets in the issue tracker of this project and we'll try to create workarounds.

## Environment ##
The installer creates a few `*.bat` files to launch a Qt command prompts and visual studio with Qt variables set. These files set a `QMAKESPEC` variable, a `QTDIR` variable and adds `%QTDIR%\bin` to the PATH. It then calls the visual studio `vcvarsall.bat` file that sets up its respective variables based on the built platform.

If you installed Qt to C:\Qt\4.5.2. The `QtVars.bat` file would look like:

```
@echo off
echo Setting QMAKESPEC to win32-msvc2008
set QMAKESPEC=win32-msvc2008
echo Setting QTDIR environment variable to C:\Qt\4.5.2
set QTDIR=C:\Qt\4.5.2
echo Putting Qt\bin in the current PATH environment variable.
set PATH=C:\Qt\4.5.2\bin;%PATH%
call "C:\Program Files\Microsoft Visual Studio 9.0\VC\vcvarsall.bat" x86
echo All done...
```

A `QtCommandPrompt.bat` is created and linked to from the start menu to pop up a command console for Qt:
```
@echo off
%COMSPEC% /k  "C:\Qt\4.5.2\QtVars.bat"
```

And finally, `QtVisualStudioStart.bat` is also linked form the start menu and looks like:
```
@echo off
call QtVars.bat
devenv /useenv
```
## qt.conf ##

The Qt documentation [for qt.conf](http://doc.trolltech.com/4.5/qt-conf.html) describes how this file works to override built in directories for Qt binaries.

The trick is to create a qt.conf in the bin directory of the relocated Qt build. For example if you installed Qt to C:\Qt\4.5.2 the qt.conf in the bin directory would look like

```
[Paths]
Prefix = C:/Qt/4.5.2
Demos = demos
Examples = examples
```

Without the `Demos` and `Examples` lines the **demo.exe** program would not work properly.

## Current Directory in QMAKE\_INCDIR ##

In Qt's provided binary distributions, the pwd is included in the QMAKE\_INCDIR and thus ends up in your projects include path as `"."`. This does not happen by default in a custom built Qt, so the installer adds the following line to `mkspecs/win32-msvc2008/qmake.conf`:

```
QMAKE_INCDIR += "."
```

## Including Extra Qt Components ##

When you add a qt component to a project file (such as `CONFIG+=uitools`), Qt looks in `%QTDIR%/lib/QtUiTools.prl` to find the library dependencies of that component. These files will have the hard coded path of the directory in which Qt was configured and built.

The Install script replaces that build directory with the one in which you install it for all `lib/*.prl` files.

## Note ##
I must thank the support team at Nokia Qt for helping with me figure out a few of these relocation tricks.