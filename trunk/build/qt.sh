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

[get_includes]
PRINT Checking out include headers
svn co $headers_url $extracted_dir/include/

[get_build]
PRINT Checking out supporting build files
svn co $build_url $source_dir/build/

[configure]
PRINT Configuring source
cat test_file
cd $extracted_dir; echo y | ./configure $config_flags
#cd $extracted_dir; echo "echo y | configure $config_flags" | cmd /k "C:\\Program Files\\Microsoft Visual Studio 9.0\\VC\\vcvarsall.bat" x86
[make]
PRINT Makeing
whoami
cd $extracted_dir; nmake

[prepare_package]
PRINT Removing .moc directories
/usr/bin/find $extracted_dir -name ".moc" -exec rm -rf {} +

PRINT Removing tmp directories
/usr/bin/find $extracted_dir -name "tmp" -exec rm -rf {} +

PRINT Clean up base dir
rm -rf $extracted_dir/*.sln
rm -rf $extracted_dir/Makefile*

PRINT Cleaning up lib
rm -rf $extracted_dir/lib/*.dll
rm -rf $extracted_dir/lib/*.exp
rm -rf $extracted_dir/lib/*.ilk
mv $extracted_dir/lib/*.pdb $extracted_dir/bin/

PRINT Cleaning up examples and demos
/usr/bin/find $extracted_dir/examples -name "debug" -exec rm -rf {} +
/usr/bin/find $extracted_dir/examples -name "*.pdb" -exec rm -rf {} +
/usr/bin/find $extracted_dir/examples -name "*.obj" -exec rm -rf {} +
/usr/bin/find $extracted_dir/examples -name "*.vcproj" -exec rm -rf {} +
/usr/bin/find $extracted_dir/examples -name "*.sln" -exec rm -rf {} +
/usr/bin/find $extracted_dir/examples -name "Makefile*" -exec rm -rf {} +
/usr/bin/find $extracted_dir/demos -name "debug" -exec rm -rf {} +
/usr/bin/find $extracted_dir/demos -name "*.pdb" -exec rm -rf {} +
/usr/bin/find $extracted_dir/demos -name "*.obj" -exec rm -rf {} +
/usr/bin/find $extracted_dir/demos -name "*.vcproj" -exec rm -rf {} +
/usr/bin/find $extracted_dir/demos -name "*.sln" -exec rm -rf {} +
/usr/bin/find $extracted_dir/demos -name "Makefile*" -exec rm -rf {} +

PRINT Cleaning up tools
/usr/bin/find $extracted_dir/tools -name "debug" -exec rm -rf {} +
/usr/bin/find $extracted_dir/tools -name "*.pdb" -exec rm -rf {} +
/usr/bin/find $extracted_dir/tools -name "*.vcproj" -exec rm -rf {} +
/usr/bin/find $extracted_dir/tools -name "*.sln" -exec rm -rf {} +
/usr/bin/find $extracted_dir/tools -name "Makefile*" -exec rm -rf {} +

PRINT Cleaning up qmake
/usr/bin/find $extracted_dir/qmake -name "*.obj" -exec rm -rf {} +

PRINT Cleaning up plugins
/usr/bin/find $extracted_dir/plugins -name "*.exp" -exec rm -rf {} +
/usr/bin/find $extracted_dir/plugins -name "*.ilk" -exec rm -rf {} +
/usr/bin/find $extracted_dir/plugins -name "*.pdb" -exec rm -rf {} +

PRINT Cleaning up src
/usr/bin/find $extracted_dir/src -name "*.pdb" -exec rm -rf {} +
/usr/bin/find $extracted_dir/src -name "*.vcproj" -exec rm -rf {} +
/usr/bin/find $extracted_dir/src -name "*Makefile" -exec rm -rf {} +
/usr/bin/find $extracted_dir/src -name "*Makefile.Release" -exec rm -rf {} +
/usr/bin/find $extracted_dir/src -name "*Makefile.Debug" -exec rm -rf {} +

[setup_package]
PRINT Making the installer in ${local_package_dir}
echo "#define MyAppName \"${product_name}\"" > ${source_dir}/install_script.iss
echo "#define MyAppNameExtra \"${name_extra}\"" >> ${source_dir}/install_script.iss
echo "#define MyAppVer \"${product_version}\"" >> ${source_dir}/install_script.iss
echo "#define MyAppVerName \"${product_full_name}\"" >> ${source_dir}/install_script.iss
echo "#define MyAppPublisher \"Packaged by gabeiscoding\"" >> ${source_dir}/install_script.iss
echo "#define MyAppURL \"${product_website}\"" >> ${source_dir}/install_script.iss
echo "#define MyAppExeName \"bin/qtdemo.exe\"" >> ${source_dir}/install_script.iss
echo "#define MyLicFile \"${base_dir}/${extracted_dir}/LICENSE.LGPL\"" >> ${source_dir}/install_script.iss
echo "#define MyAppId \"{${app_id}\"" >> ${source_dir}/install_script.iss
echo "#define MyPlatform \"${os_abbrev}\"" >> ${source_dir}/install_script.iss
echo "#define MyPlatformCode \"${os_code}\"" >> ${source_dir}/install_script.iss
echo "#define MyOutputDir \"${base_dir}/${local_package_dir}\"" >> ${source_dir}/install_script.iss
echo "#define MyStageDir \"${base_dir}/${extracted_dir}\"" >> ${source_dir}/install_script.iss
echo "#define MyScriptWriterPath \"${base_dir}/${source_dir}/build/write-launch-script.js\"" >> ${source_dir}/install_script.iss
echo "#define MyRedistPath \"${base_dir}/${source_dir}/build/${redist_name}\"" >> ${source_dir}/install_script.iss
echo "#define MyOrigPath \"${base_dir}/${extracted_dir}\"" >> ${source_dir}/install_script.iss
echo "#define MySetupIconPath \"${base_dir}/${extracted_dir}/demos/qtdemo/qtdemo.ico\"" >> ${source_dir}/install_script.iss

tail -n +18 ${source_dir}/build/setup.iss >> ${source_dir}/install_script.iss
"$istool_exe" -compile ${source_dir}/install_script.iss

chmod a+rx ${local_package_dir}/${product_name}-${os_abbrev}-${product_version}${name_extra}.exe
rm -rf ${local_package_dir}/${final_package_name}
mv ${local_package_dir}/${product_name}-${os_abbrev}-${product_version}${name_extra}.exe ${local_package_dir}/${final_package_name}

