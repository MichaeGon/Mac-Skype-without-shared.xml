#!/bin/sh

skype=/Applications/Skype.app
appname='SkypeWithoutXml'
icns='SkypeBlue.icns'
sharedxml='~/Library/Application\ Support/Skype/shared.xml'

mkdir -p ${appname}.app/Contents/{MacOS,Resources}
cat > ${appname}.app/Contents/Info.plist <<END
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
  <dict>
    <key>CFBundleExecutable</key>
    <string>${appname}.sh</string>
    <key>CFBundleIconFile</key>
    <string>${icns}</string>
  </dict>
</plist>
END

cat > ${appname}.app/Contents/MacOS/${appname}.sh <<END
#!/bin/sh

if [ -e ${sharedxml} ]
    then
    rm ${sharedxml}
fi

open ${skype}
END

cp ${skype}/Contents/Resources/${icns} ${appname}.app/Contents/Resources/
chmod +x ${appname}.app/Contents/MacOS/${appname}.sh
