#!/bin/bash

# args: releasetag changelogmessage

[[ $# -ne 2 ]] && echo "need release tag and release massage" && exit 1

name="AuditTAP"

tmp=$(mktemp --tmpdir -d ATAPXXXXXXX)
scriptDir=$(cd $(dirname "${BASH_SOURCE[0]}") && pwd)
assets="$scriptDir/assets_DEB/*"
tmpFolder="$tmp/$name"
modules="$tmpFolder/opt/microsoft/powershell/7/Modules"
changelog="$tmpFolder/usr/share/doc/$name/changelog.Debian"
control="$tmpFolder/DEBIAN/control"


# create dir structure
mkdir $tmpFolder
cp -r -t $tmpFolder $assets


# copie needed files, create changelog with releasetag, update control Version
cp -r -t $modules "$scriptDir/../../ATAPAuditor" "$scriptDir/../../ATAPHtmlReport"
rm "$modules/nonempty"
DATE=$(date -R)
sed -i "s/<version>/($1)/ ; s/<DATE>/$DATE/" "$changelog"
while read x; do # multiline replace with all special characters
    [[ "$x" =~ "/" ]] && x=$(echo $x | sed 's+/+\\\/+')
    sed -i "s/<message>/$x\n<message>/" $1
done <<< $2
sed -i 's/<message>//' $1
gzip --best -n "$changelog"
sed -i "s/<version>/$1/" "$control"
echo -n "License: ""$(cat LICENSE)" >> "$control"


# create & move package and remove dir structure
dpkg-deb --root-owner-group --build "$tmpFolder" # &>/dev/null
mv "$tmp/$name.deb" ./$name-$1.deb && echo "$name.deb successfully created"
rm -r $tmp


exit 0
