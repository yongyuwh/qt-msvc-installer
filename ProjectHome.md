<font color='red'>Qt <b>4.8.4</b> is built and uploaded (see notes below about NoQt3 using -no-plugin-manifests) ... Notice by limitation of google code 200mb upload limit, the installer has been broken up into two disk-spanning files (remember those?). Download the installer and it's two "bin" files into the same directory and then run.</font>


You can download Qt from their website directly at http://www.qtsoftware.com/downloads

But unless you have a commercial license, Nokia does not redistribute a installer for the Qt libraries built with MSVC 2008 (Edit: this has changed, see below). The pre-compiled libraries provided are compiled with mingw.

The open source version of Qt4 since 4.4 has full support for being built with Visual Studio. To build your own installer similar to the commercial Qt MSVC installer is possible, but would take quite a few steps. This project does it for you.

This project is a convinient build of the Qt libraries for MSVC 2008 wrapped in an installer that will include:

  * Uninstall entry
  * Command prompt with proper environment variables already set
  * Launch MSVC with proper environment variables already set
  * Qt Assistant/Designer/Translator shortcut
  * .ui file association with Qt Designer (unselectable in installer)
  * Cleaned up build of full Qt libraries ~ 750MB (compared to ~4.5GB after config/nmake)
  * 64-bit versions for a full 64-bit library stack of Qt.

This project intends provides all the conveniences of pre-build packages you get with the commercial version of Qt available with the LGPL licensed Qt libraries.

## Releases ##
  * In the 4.8.1 release, I changed the "NoQt3" builds to be compile plug-ins with the _-no-plugin-manifest_ option to allow for the MSVC runtime to be deployed as a "local assembly" (put the msvcrt.dll etc in the same directory as your executable) and still be able to load plugins. This is how my deploys are going to work. If that's not for you, use the builds that include Qt3 support.
  * The 4.5.2 was the first release and there some issues discovered with it (did not play well with QtCreater, moc in windows Makefiles did not run)
  * 4.5.3 attempted to fix these issues and also compiled th MySql Postgres and Oracle client database plug-ins.
  * 4.6.2 Finally figured out my build issues with the 4.6.x codebase. Had to take some aggressive measures to keep the final installer size below the 200mb code.google.com limit.

Now for 4.6.0, Nokia went ahead and provided an installer for MSVC 2008 binaries of Qt LGPL. Compared to the official Nokia build, the real main advantage of this project is providing pre-built binaries for 64-bit windows and builds without Qt3.

## Download ##

This project is built with build scripts using [the ramses build system](http://code.google.com/p/ramses-build/).

The "-noqt3-" version is built with the -no-qt3support flag set when configuring Qt. This removes some deprecated functions from the libraries and does not build the Qt3Support.dll file.

The latest builds should be on the right as "Featured downloads"

## Qt Creator 64-bit ##

Net147 provided binaries for Qt Creator 64-bit available [in this ticket](http://code.google.com/p/qt-msvc-installer/issues/detail?id=8)

## Qt Support for Relocating Builds on Windows ##
Technically, Qt does not support building their Qt libraries in one location and installing them to another. This installer _does_ allows you to pick where you install the Qt libraries and I have done quite a few nuanced tricks to make it work.

As far as I can tell, the installer produces a fully functioning Qt build that builds every complex Qt project I have thrown at it, but because of the unsupported nature of the build/relocate setup, you may run into obscure issues. Feel free to create tickets in the issue tracker of this project and we'll try to create workarounds.

Under RelocationTricks I document what I have the installer do so far to handle relocation.

## Prerequisite And Known Issues ##
The installer runs a JScript script to do the relocation work. If you Windows Scripting Host disabled you will run into issues. All windows systems have `cscript` available, but some have it locked down for security issues.

Also, as Yücel Ahi pointed out, if your application is wanting to load Qt plugins from the install directory, you will need a qt.conf file in your application directory. So far I have not discovered a trick to modify the default search path for plugins without a qt.conf file. If you have, please let me know!

## Visual Studio Addin ##

Nokia Qt have recently made available a VS add-in as open source and free as well (Thanks to Yuecel for noting this is not the same as the VS Integration Tool which appears to be commercial license only). The [Visual Studio Add In tool](http://qt.nokia.com/developer/faqs/what-is-the-visual-studio-add-in/view) can be [downloaded here](http://www.qtsoftware.com/downloads/visual-studio-add-in) from qtsoftware.com. It should work fine with this packaged build with the Qt Open Source Edition and Visual Studio 2008.

## Qt Creator Support ##

With the 4.5.3 and greater builds and Qt Creator 1.3.0 or greater (http://qt.nokia.com/downloads/qt-creator-binary-for-windows) you can use these Qt builds with Qt creator. The easiest way to have your Qt installation recognized is to start Qt Creator from the Qt Command Line (where QTPATH is set). For debugging you can "Rebuild" the Qt debugger helper tools. The only problem I ran into is debugging 64-bit Qt applications which I'm not sure the 32-bit QtCreator is capable of.

## Lightweight Alternative to Visual Studio Addin ##

You can also use custom build rules for Qt and MSVC like [xr-qt-msvc](http://code.google.com/p/xr-qt-msvc/) on top of these pre-compiled Qt binaries if you are looking for something more lightweight and customizable than the Nokia visual studio add-in and qmake generated projects.
## A Note on Compiling through Cygwin SSHd ##

There has been a long standing bug that causes problems when you try to compile with debug enabled (`cl.exe /Zi`) over SSH. MS dev people tooks some blame and said it was fixed in MSVS 2005. Cygwin people took some blame and said it was fixed in cygwin 1.7. But I still had problems with Visual Studio 2008 SP1 and Cygwin 1.7.

The problem appears to sometimes manifests itself as [LINK : fatal error LNK1101: incorrect MSPDB80.DLL version; recheck installation of this product](http://connect.microsoft.com/VisualStudio/feedback/ViewFeedback.aspx?FeedbackID=99379) where cgywin folks [suggest](http://cygwin.com/ml/cygwin/2008-08/msg00176.html) you use 1.7 [multiple times](http://www.nabble.com/Return-of-C1902-td18846324.html).

It also manifests itself as a [fatal error C1902: Program database manager mismatch; please check your installation C1902 fatal error](http://connect.microsoft.com/VisualStudio/feedback/ViewFeedback.aspx?FeedbackID=99676) and from the [multiple](http://social.msdn.microsoft.com/forums/en-US/vcgeneral/thread/ce48212e-9731-4539-b6fd-8cc92195c69f/) MSDN [discussions](http://social.msdn.microsoft.com/Forums/en-US/vcgeneral/thread/22a3cc87-7052-4ede-9a1b-81e49ab41d0d) you get the info that it has to do with the sshd session tweaking the sessions user credentials enough that mspdbsrv.exe gets confused and quits. This was enough insight to start tweaking things to get a working configuration:

  * Cygwin 1.7 SSH/SSHd (used [standard setup instructions](http://pigtail.net/LRP/printsrv/cygwin-sshd.html))
  * Edit /etc/sshd\_config and set `UsePrivilegeSeparation no` (Not sure if this was necessary)
  * Visual Studio 2008 SP1
  * In Windows Services Manager, edited CYGWIN sshd to run as my user, not as system. Restart the service.

I hope that helps save somebody some time.

## Contact and Feedback ##
Let me know if you find this project useful or have any feedback and/or suggestions.

Gabe Rudy <gabe.rudy at gmail.com>