{-# OPTIONS_GHC -Wall -Werror #-}

import System.Directory
import System.FilePath
import System.Process

skype :: FilePath
skype = "/Applications" </> "Skype" <.> "app"

configs :: FilePath
configs = "Library" </> "Application Support" </> "Skype"

xml :: FilePath
xml = "shared" <.> "xml"

plist :: FilePath
plist = "Info" <.> "plist"

appName :: FilePath
appName = "SkypeWitoutXml"

iconName :: FilePath
iconName = "SkypeBlue" <.> "icns"

plistContents :: String
plistContents = unlines [
        "<?xml version=\"1.0\" encoding=\"UTF-8\"?>",
        "<!DOCTYPE plist PUBLIC \"-//Apple Computer//DTD PLIST 1.0//EN\" \"http://www.apple.com/DTDs/PropertyList-1.0.dtd\">",
        "<plist version=\"1.0\">",
        "\t<dict>",
        "\t\t<key>CFBundleExecutable</key>",
        "\t\t<string>" ++ appName ++ "</string>",
        "\t\t<key>CFBundleIconFile</key>",
        "\t\t<string>" ++ iconName ++ "</string>",
        "\t</dict>",
        "</plist>"]

executableContents :: FilePath -> String
executableContents home = unlines [
    "import System.Directory",
    "import System.Process",
    "import System.FilePath",
    "main = doesFileExist \"" ++ ppath ++ "\" >>= removeXml >> callCommand \"open " ++ skype ++ "\"",
    "\twhere",
    "\t\tremoveXml x",
    "\t\t\t| x = removeFile \"" ++ ppath ++ "\"",
    "\t\t\t| otherwise = return ()"]
        where
            ppath = home </> configs </> xml

main :: IO ()
main = createBundleDirectory
    >> writePlist
    >> makeExecutable

createBundleDirectory :: IO ()
createBundleDirectory = createDirectory (appName <.> "app")
                        >> createDirectory contdir
                        >> createDirectory (contdir </> "MacOS")
                        >> createDirectory (contdir </> "Resources")
    where
        contdir = appName <.> "app" </> "Contents"

{-
removeXml :: Bool -> IO ()
removeXml doesExist
    | doesExist = makeAbsolute (configs </> xml) >>= removeFile
    | otherwise = return ()
-}

writePlist :: IO ()
writePlist = writeFile path plistContents
    where
        path = appName <.> "app" </> "Contents" </> plist

makeExecutable :: IO ()
makeExecutable = getHomeDirectory
                >>= writeFile hsSource . executableContents
                >> callCommand ("ghc " ++ hsSource)
                >> copyFile appName exepath
                >> copyFile iconpath dist
    where
        hsSource = appName <.> "hs"
        cntdir = appName <.> "app" </> "Contents"
        exepath = cntdir </> "MacOS" </> appName
        iconpath = skype </> "Contents" </> "Resources" </> iconName
        dist = cntdir </> "Resources" </> iconName
