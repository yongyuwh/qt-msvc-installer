#Qt build script

[clean_source]
PRINT Cleaning out source directory...
rm -rf $source_dir

[download_source]
PRINT Downloading the source code
mkdir -p $source_dir
wget --progress=dot:mega -O $source_dir/${abbrev_name}.zip $download_url 

[unzip_source]
PRINT Unzipping the source code
#Note: This unzip program that is assumed whould be a InfoZip unzip
#program build for windows. A cygwin unzip binary will screw up
#permissions for executable files as it extracts, preventing proper
#builds.
cd $source_dir; unzip ${abbrev_name}.zip
rm -rf $build_dir
mv $extracted_dir $build_dir

[get_includes]
PRINT Checking out include headers
svn co $headers_url $build_dir/include/
PRINT Removing traces of svn
/usr/bin/find $build_dir/include/ -name ".svn" -exec rm -rf {} +

[get_build]
PRINT Checking out supporting build files
svn co $build_url $source_dir/build/
cd $build_dir; patch -p0 < ${base_dir}/$source_dir/build/qlibraryinfo.patch

[configure]
PRINT Configuring source
#env
cd $build_dir; echo y | ./configure.exe $config_flags
#cd $build_dir; echo "echo y | configure $config_flags" | cmd /k "C:\\Program Files\\Microsoft Visual Studio 9.0\\VC\\vcvarsall.bat" x86

[write_configure_script]
PRINT Give up on trying to get the build system happy with the cygwin env, run this in the proper MSVC cmd env
echo "echo y | configure.exe $config_flags" > $build_dir/build_script.bat
echo "nmake" >> $build_dir/build_script.bat


[make]
PRINT Makeing
cd $build_dir; nmake

[prepare_package]
PRINT Removing .moc directories
/usr/bin/find $build_dir -name ".moc" -exec rm -rf {} +

PRINT Removing tmp directories
/usr/bin/find $build_dir -name "tmp" -exec rm -rf {} +

PRINT Clean up base dir
rm -rf $build_dir/*.sln
rm -rf $build_dir/Makefile*

PRINT Cleaning up lib
rm -rf $build_dir/lib/*.dll
rm -rf $build_dir/lib/*.exp
rm -rf $build_dir/lib/*.ilk
mv $build_dir/lib/*.pdb $build_dir/bin/

PRINT Cleaning up examples and demos
/usr/bin/find $build_dir/examples -name "debug" -exec rm -rf {} +
/usr/bin/find $build_dir/examples -name "*.pdb" -exec rm -rf {} +
/usr/bin/find $build_dir/examples -name "*.obj" -exec rm -rf {} +
/usr/bin/find $build_dir/examples -name "*.vcproj" -exec rm -rf {} +
/usr/bin/find $build_dir/examples -name "*.sln" -exec rm -rf {} +
/usr/bin/find $build_dir/examples -name "Makefile*" -exec rm -rf {} +
/usr/bin/find $build_dir/demos -name "debug" -exec rm -rf {} +
/usr/bin/find $build_dir/demos -name "*.pdb" -exec rm -rf {} +
/usr/bin/find $build_dir/demos -name "*.obj" -exec rm -rf {} +
/usr/bin/find $build_dir/demos -name "*.vcproj" -exec rm -rf {} +
/usr/bin/find $build_dir/demos -name "*.sln" -exec rm -rf {} +
/usr/bin/find $build_dir/demos -name "Makefile*" -exec rm -rf {} +

PRINT Cleaning up tools
/usr/bin/find $build_dir/tools -name "debug" -exec rm -rf {} +
/usr/bin/find $build_dir/tools -name "*.pdb" -exec rm -rf {} +
/usr/bin/find $build_dir/tools -name "*.vcproj" -exec rm -rf {} +
/usr/bin/find $build_dir/tools -name "*.sln" -exec rm -rf {} +
/usr/bin/find $build_dir/tools -name "Makefile*" -exec rm -rf {} +

PRINT Cleaning up qmake
/usr/bin/find $build_dir/qmake -name "*.obj" -exec rm -rf {} +

PRINT Cleaning up plugins
/usr/bin/find $build_dir/plugins -name "*.exp" -exec rm -rf {} +
/usr/bin/find $build_dir/plugins -name "*.ilk" -exec rm -rf {} +
/usr/bin/find $build_dir/plugins -name "*.pdb" -exec rm -rf {} +

PRINT Cleaning up src
/usr/bin/find $build_dir/src -name "*.pdb" -exec rm -rf {} +
/usr/bin/find $build_dir/src -name "*.vcproj" -exec rm -rf {} +
/usr/bin/find $build_dir/src -name "*Makefile" -exec rm -rf {} +
/usr/bin/find $build_dir/src -name "*Makefile.Release" -exec rm -rf {} +
/usr/bin/find $build_dir/src -name "*Makefile.Debug" -exec rm -rf {} +

/usr/bin/find $build_dir/src/tools -name "*.obj" -exec rm -rf {} +
/usr/bin/find $build_dir/src -name "ChangeLog*" -exec rm -rf {} +
rm -rf $build_dir/src/3rdparty/webkit/WebCore/obj
rm -rf $build_dir/src/script/obj
rm -rf $build_dir/doc/src


[setup_package]
PRINT Making the installer in ${local_package_dir}
echo "#define MyAppName \"${product_name}\"" > ${source_dir}/install_script.iss
echo "#define MyAppNameExtra \"${name_extra}\"" >> ${source_dir}/install_script.iss
echo "#define MyAppVer \"${product_version}\"" >> ${source_dir}/install_script.iss
echo "#define MyAppVerName \"${product_full_name}\"" >> ${source_dir}/install_script.iss
echo "#define MyAppPublisher \"Packaged by gabeiscoding\"" >> ${source_dir}/install_script.iss
echo "#define MyAppURL \"${product_website}\"" >> ${source_dir}/install_script.iss
echo "#define MyAppExeName \"bin/qtdemo.exe\"" >> ${source_dir}/install_script.iss
echo "#define MyLicFile \"${base_dir}/${build_dir}/LICENSE.LGPL\"" >> ${source_dir}/install_script.iss
echo "#define MyAppId \"{${app_id}\"" >> ${source_dir}/install_script.iss
echo "#define MyPlatform \"${os_abbrev}\"" >> ${source_dir}/install_script.iss
echo "#define MyPlatformCode \"${platform_code}\"" >> ${source_dir}/install_script.iss
echo "#define MyOSCode \"${os_code}\"" >> ${source_dir}/install_script.iss
echo "#define MyOutputDir \"${base_dir}/${local_package_dir}\"" >> ${source_dir}/install_script.iss
echo "#define MyStageDir \"${base_dir}/${build_dir}\"" >> ${source_dir}/install_script.iss
echo "#define MyScriptWriterPath \"${base_dir}/${source_dir}/build/write-launch-script.js\"" >> ${source_dir}/install_script.iss
echo "#define MyRedistPath \"${base_dir}/${source_dir}/build/${redist_name}\"" >> ${source_dir}/install_script.iss
echo "#define MyOrigPath \"${base_dir}/${build_dir}\"" >> ${source_dir}/install_script.iss
echo "#define MySetupIconPath \"${base_dir}/${build_dir}/demos/qtdemo/qtdemo.ico\"" >> ${source_dir}/install_script.iss

tail -n +19 ${source_dir}/build/setup.iss >> ${source_dir}/install_script.iss
"$istool_exe" -compile ${source_dir}/install_script.iss

chmod a+rx ${local_package_dir}/${product_name}-${os_abbrev}-${product_version}${name_extra}.exe
rm -rf ${local_package_dir}/${final_package_name}
mv ${local_package_dir}/${product_name}-${os_abbrev}-${product_version}${name_extra}.exe ${local_package_dir}/${final_package_name}

PRINT Printing submit info to text file
echo "${product_full_name} Installer" > ${base_dir}/${local_package_dir}/${final_package_name}.txt
echo "Featured,Type-Installer,${os_type}" >> ${base_dir}/${local_package_dir}/${final_package_name}.txt
