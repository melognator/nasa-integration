#!/bin/bash

java -jar SfApexDoc.jar -s "../force-app/main/default/classes" -a author -p global,public,protected,private
rm -rf "../docs"
mv -T "SfApexDocs" "../docs" 