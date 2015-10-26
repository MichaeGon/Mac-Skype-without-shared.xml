# Mac-Skype-without-shared.xml
MacのSkypeの調子がおかしい時用<br />

## 使い方
sh/install.sh <br />
で出来上がったappをお使いください<nr />

## Haskellの方
こんなクソShellScript使わせてないでHaskell使わせろという人向け<br />
<br />
cd hs<br />
cabal build<br />
cd dist/build/install/<br />
./install<br />
<br />
または<br />
<br />
cd hs <br />
ghc install.hs<br />
./install<br />
で出来上がったappをお使いください<br />

### 動作確認環境
OS X El capitan<br />
ghc 7.10.2<br />
cabal 1.22.6<br />
