@echo off

if not exist .deps/ (
    git clone https://github.com/thinca/vim-themis .deps/themis/
    git clone https://github.com/vim-jp/vital.vim  .deps/vital/
)

.deps\themis\bin\themis.bat --runtimepath .deps/vital/ --recursive
