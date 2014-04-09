#!/bin/bash

haxe test.hxml

libname='DeepHash'

rm -f "${libname}.zip"
zip -r "${libname}.zip" haxelib.json LICENSE README src test.hxml

