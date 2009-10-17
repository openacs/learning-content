#!/bin/bash

cd ../../
patch -p0 -i learning-content/learning-content-patch/evaluation-diff.patch
patch -p0 -i learning-content/learning-content-patch/assessment-diff.patch
patch -p0 -i learning-content/learning-content-patch/forums-diff.patch
patch -p0 -i learning-content/learning-content-patch/acs-subsite-diff.patch
cp -r learning-content/learning-content-patch/InsertGlossaryEntry/ acs-templating/www/resources/xinha-nightly/plugins/
