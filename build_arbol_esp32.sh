#!/bin/bash

# rm -f ~/Documents/Arduino/arboltmp/arboltmp.ino
ruby lib/builder.rb $1
cat ~/Documents/Arduino/executor2/executor2.ino arbol_tmp.rb > arboltmp.ino

mkdir -p ~/Documents/Arduino/arboltmp

cp arboltmp.ino ~/Documents/Arduino/arboltmp/arboltmp.ino
open ~/Documents/Arduino/arboltmp/arboltmp.ino