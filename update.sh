#!/bin/sh
echo "------------------"

echo "Building Packages...."
apt-ftparchive packages ./debs/ > ./Packages;
bzip2 -9fkv ./Packages > ./Packages.bz2;
gzip -9fkv ./Packages > ./Packages.gz;
xz -9fkev ./Packages > ./Packages.xz;
xz -9fkev --format=lzma ./Packages > ./Packages.lzma;
echo "Build Packages Done"

echo "Building Release...."
printf "Origin: Add repo.tuandb.name.vn\nLabel: Add repo.tuandb.name.vn\nSuite: stable\nVersion: 1.0\nCodename: ios\nArchitectures: iphoneos-arm\nComponents: main\nDescription: Nguồn mới repo.tuandb.name.vn\nMD5Sum:\n "$(cat ./Packages | md5sum | cut -d ' ' -f 1)" "$(stat ./Packages --printf="%s")" Packages\n "$(cat ./Packages.bz2 | md5sum | cut -d ' ' -f 1)" "$(stat ./Packages.bz2 --printf="%s")" Packages.bz2\n "$(cat ./Packages.gz | md5sum | cut -d ' ' -f 1)" "$(stat ./Packages.gz --printf="%s")" Packages.gz\n "$(cat ./Packages.xz | md5sum | cut -d ' ' -f 1)" "$(stat ./Packages.xz --printf="%s")" Packages.xz\n "$(cat ./Packages.lzma | md5sum | cut -d ' ' -f 1)" "$(stat ./Packages.lzma --printf="%s")" Packages.lzma\nSHA1:\n "$(cat ./Packages | sha1sum | cut -d ' ' -f 1)" "$(stat ./Packages --printf="%s")" Packages\n "$(cat ./Packages.bz2 | sha1sum | cut -d ' ' -f 1)" "$(stat ./Packages.bz2 --printf="%s")" Packages.bz2\n "$(cat ./Packages.gz | sha1sum | cut -d ' ' -f 1)" "$(stat ./Packages.gz --printf="%s")" Packages.gz\n "$(cat ./Packages.xz | sha1sum | cut -d ' ' -f 1)" "$(stat ./Packages.xz --printf="%s")" Packages.xz\n "$(cat ./Packages.lzma | sha1sum | cut -d ' ' -f 1)" "$(stat ./Packages.lzma --printf="%s")" Packages.lzma\nSHA256:\n "$(cat ./Packages | sha256sum | cut -d ' ' -f 1)" "$(stat ./Packages --printf="%s")" Packages\n "$(cat ./Packages.bz2 | sha256sum | cut -d ' ' -f 1)" "$(stat ./Packages.bz2 --printf="%s")" Packages.bz2\n "$(cat ./Packages.gz | sha256sum | cut -d ' ' -f 1)" "$(stat ./Packages.gz --printf="%s")" Packages.gz\n "$(cat ./Packages.xz | sha256sum | cut -d ' ' -f 1)" "$(stat ./Packages.xz --printf="%s")" Packages.xz\n "$(cat ./Packages.lzma | sha256sum | cut -d ' ' -f 1)" "$(stat ./Packages.lzma --printf="%s")" Packages.lzma\nSHA512:\n "$(cat ./Packages | sha512sum | cut -d ' ' -f 1)" "$(stat ./Packages --printf="%s")" Packages\n "$(cat ./Packages.bz2 | sha512sum | cut -d ' ' -f 1)" "$(stat ./Packages.bz2 --printf="%s")" Packages.bz2\n "$(cat ./Packages.gz | sha512sum | cut -d ' ' -f 1)" "$(stat ./Packages.gz --printf="%s")" Packages.gz\n "$(cat ./Packages.xz | sha512sum | cut -d ' ' -f 1)" "$(stat ./Packages.xz --printf="%s")" Packages.xz\n "$(cat ./Packages.lzma | sha512sum | cut -d ' ' -f 1)" "$(stat ./Packages.lzma --printf="%s")" Packages.lzma\n" >Release;
echo "Build Release Done"

echo "Building all.packages...."
ls ./debs/ -t | grep '.deb' | perl -e 'use JSON; @in=grep(s/\n$//, <>); $count=0; foreach $fileNow (@in) { $fileNow = "./debs/$fileNow"; $size = -s $fileNow; $debInfo = `dpkg -f $fileNow`; $section = `echo "$debInfo" | grep "Section: " | cut -c 10- | tr -d "\n\r"`; $name= `echo "$debInfo" | grep "Name: " | cut -c 7- | tr -d "\n\r"`; $version= `echo "$debInfo" | grep "Version: " | cut -c 10- | tr -d "\n\r"`; $package= `echo "$debInfo" | grep "Package: " | cut -c 10- | tr -d "\n\r"`; $time= `date -r $fileNow +%s | tr -d "\n\r"`; @in[$count] = {section=>$section, package=>$package, version=>$version, size=>$size+0, time=>$time+0, name=>$name}; $count++; } print encode_json(\@in)."\n";' > all.packages;
echo "Build all.packages Done"

echo "------------------"
echo "Done!"
exit 0;
