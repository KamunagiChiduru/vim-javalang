#!/usr/bin/bash

if ! [ -d .deps ]; then
    git clone https://github.com/thinca/vim-themis .deps/themis/
    git clone https://github.com/vim-jp/vital.vim  .deps/vital/
fi

./.deps/themis/bin/themis --runtimepath ./.deps/vital/ --recursive $*
