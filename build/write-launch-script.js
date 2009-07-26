//Args
var args = WScript.Arguments;
var shell = WScript.CreateObject("WScript.Shell");
var progName = args(0);
var progPath = args(1);
var platform = args(2);
var varsFile = progPath + "\\" + progName + "Vars.bat";
var varsPlatformCode = "x86";
var fso, tf;
if (platform != "Win32"){
  varsPlatformCode = "x86_amd64";
  WScript.Echo("setting x86_amd64 platform code");
}
var installDir;

try{
  installDir = shell.RegRead("HKEY_LOCAL_MACHINE\\SOFTWARE\\Microsoft\\VisualStudio\\9.0\\InstallDir");
  //Remove the "Common7\IDE\" at the end of the dir
  installDir = installDir.substring(0,installDir.length-12);
  WScript.Echo("Found VS 2008 at: " + installDir);
}catch(exception){
  shell.Popup("A installation of Visual Studio 2008 was not found in the registry, guessing path...");
  installDir = "C:\\Program Files\\Microsoft Visual Studio 9.0\\";
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

tf = fso.CreateTextFile(progPath + "\\" + progName + "CommandPrompt.bat", true);
//Write out the cmd bat file
tf.WriteLine("@echo off");
tf.WriteLine("%COMSPEC% /k  \"" + varsFile + "\"");
tf.Close();

tf = fso.CreateTextFile(progPath + "\\" + progName + "VisualStudioStart.bat", true);
//Write out the cmd bat file
tf.WriteLine("@echo off");
tf.WriteLine("call " + progName + "Vars.bat");
tf.WriteLine("devenv /useenv");
tf.Close();
