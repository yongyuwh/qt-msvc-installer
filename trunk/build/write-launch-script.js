//Args
var args = WScript.Arguments;
var shell = WScript.CreateObject("WScript.Shell");
var progName = args(0);
var progPath = args(1);
var oldPath  = args(2);
var platform = args(3);
var varsFile = progPath + "\\" + progName + "Vars.bat";
var varsPlatformCode = "x86";
var fso, tf;
if (platform != "Win32"){
  varsPlatformCode = "x86_amd64";
  WScript.Echo("setting x86_amd64 platform code");
}
var installDir;
WScript.Echo("'" + oldPath + "'");

try{
  installDir = shell.RegRead("HKEY_LOCAL_MACHINE\\SOFTWARE\\Microsoft\\VisualStudio\\9.0\\InstallDir");
  //Remove the "Common7\IDE\" at the end of the dir
  installDir = installDir.substring(0,installDir.length-12);
  WScript.Echo("Found VS 2008 at: " + installDir);
}catch(exception){
  try{
    installDir = shell.RegRead("HKEY_LOCAL_MACHINE\\SOFTWARE\\Wow6432Node\\Microsoft\\VisualStudio\\9.0\\InstallDir");
    //Remove the "Common7\IDE\" at the end of the dir
    installDir = installDir.substring(0,installDir.length-12);
    WScript.Echo("Found VS 2008 at: " + installDir);
  }catch(exception){
    shell.Popup("A installation of Visual Studio 2008 was not found in the registry, guessing path...");
    installDir = "C:\\Program Files\\Microsoft Visual Studio 9.0\\";
  }
}
fso = new ActiveXObject("Scripting.FileSystemObject");
WScript.Echo("Writting " + varsFile);
tf = fso.CreateTextFile(varsFile, true);

//Write out the vars bat file
tf.WriteLine("@echo off");
tf.WriteLine("echo Setting QMAKESPEC to win32-msvc2008");
tf.WriteLine("set QMAKESPEC=win32-msvc2008");
tf.WriteLine("echo Setting QTDIR environment variable to " + progPath);
tf.WriteLine("set QTDIR="+progPath);
tf.WriteLine("echo Putting " + progName +"\\bin in the current PATH environment variable.");
tf.WriteLine("set PATH="+progPath+"\\bin;%PATH%");
tf.WriteLine("call \"" + installDir + "VC\\vcvarsall.bat\" " + varsPlatformCode); //Might pass 'x86' or 'x64' in future
tf.WriteLine("echo All done...");
tf.Close();

//Command prompt launcher
tf = fso.CreateTextFile(progPath + "\\" + progName + "CommandPrompt.bat", true);
//Write out the cmd bat file
tf.WriteLine("@echo off");
tf.WriteLine("%COMSPEC% /k  \"" + varsFile + "\"");
tf.Close();

//Visual Studio launcher
tf = fso.CreateTextFile(progPath + "\\" + progName + "VisualStudioStart.bat", true);
//Write out the cmd bat file
tf.WriteLine("@echo off");
tf.WriteLine("call " + progName + "Vars.bat");
tf.WriteLine("devenv /useenv");
tf.Close();

//Write qt.conf in bin dir
re = /\\/g;
qtProgPath = progPath.replace(re,"\\\\");
tf = fso.CreateTextFile(progPath + "\\bin\\qt.conf", true);
//Write out the cmd bat file
tf.WriteLine("[Paths]");
tf.WriteLine("Prefix = " + qtProgPath);
tf.WriteLine("Demos = demos");
tf.WriteLine("Examples = examples");
tf.Close();

//Append "." to QMAKE_INCDIR in qmake.conf (don't know why it doesn't go in automatically
var ForReading = 1, ForAppending = 8;
tf = fso.OpenTextFile(progPath + "\\mkspecs\\win32-msvc2008\\qmake.conf", ForAppending);
tf.writeline("QMAKE_INCDIR += \".\"");
tf.Close();

//Replace build location with install location in all lib/*.prl files
var libFolder = fso.GetFolder(progPath + "\\lib");
var collection = libFolder.Files;
var e = new Enumerator(collection)
for (; !e.atEnd(); e.moveNext()){
  var t = e.item();
            //WScript.Echo(t.Path);
  if(t.Path.match(".prl$"))
  {
    WScript.Echo("Fixing paths in: " + t.Path);
    tf = fso.OpenTextFile(t.Path, ForReading);
    var text = tf.ReadAll();
    tf.Close();
    var re = new RegExp(oldPath.replace(/\//g, "\\\\"), "gim");
    text = text.replace(re, progPath);
    tf = fso.CreateTextFile(t.Path, true);
    tf.Write(text);
    tf.Close();
  }
}

//Set proper qmake variables (Not necessary with qt.conf properly configured)
// shell.Run("\"" + progPath + "\\bin\\qmake.exe\" -set QT_INSTALL_PREFIX \"" + progPath + "\"");
// shell.Run("\"" + progPath + "\\bin\\qmake.exe\" -set QT_INSTALL_DATA \"" + progPath + "\"");
// shell.Run("\"" + progPath + "\\bin\\qmake.exe\" -set QT_INSTALL_DOCS \"" + progPath + "\\doc\"");
// shell.Run("\"" + progPath + "\\bin\\qmake.exe\" -set QT_INSTALL_HEADERS \"" + progPath + "\\include\"");
// shell.Run("\"" + progPath + "\\bin\\qmake.exe\" -set QT_INSTALL_LIBS \"" + progPath + "\\lib\"");
// shell.Run("\"" + progPath + "\\bin\\qmake.exe\" -set QT_INSTALL_BINS \"" + progPath + "\\bin\"");
// shell.Run("\"" + progPath + "\\bin\\qmake.exe\" -set QT_INSTALL_PLUGINS \"" + progPath + "\\plugins\"");
// shell.Run("\"" + progPath + "\\bin\\qmake.exe\" -set QT_INSTALL_TRANSLATIONS \"" + progPath + "\\translations\"");
// shell.Run("\"" + progPath + "\\bin\\qmake.exe\" -set QT_INSTALL_CONFIGURATION \"" + progPath + "\"");
// shell.Run("\"" + progPath + "\\bin\\qmake.exe\" -set QT_INSTALL_EXAMPLES \"" + progPath + "\\examples\"");
// shell.Run("\"" + progPath + "\\bin\\qmake.exe\" -set QT_INSTALL_DEMOS \"" + progPath + "\\demos\"");
// shell.Run("\"" + progPath + "\\bin\\qmake.exe\" -set QMAKE_MKSPECS \"" + progPath + "\\mkspecs\"");
