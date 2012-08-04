#!/bin/bash

if [ -e DeepHash.zip ]; then
    rm DeepHash.zip
fi

zip DeepHash.zip haxelib.xml LICENSE README *.hx test.hxml
