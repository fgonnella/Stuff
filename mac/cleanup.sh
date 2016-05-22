#!/bin/bash
ls | while read -r FILE
do
    mv -v "$FILE" `echo ${FILE} |  iconv -f utf-8 -t ASCII -c | tr ' ' '_'`
done
