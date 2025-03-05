#!/bin/bash

usage="Usage: $0 [subcommand] [filename or extension]\n"
sub="\nsubcommand:\n$0 test [filename or extension]\n$0 create [filename or extension]\n"
ex="\nexample:\n$0 create .gz"

if [ "$#" -lt 2 ]; then
    echo -e "ERROR: Filename or Extension argument is missing!"
    echo -e "$usage$sub$ex"
    exit 1
fi

if ["$1" == "test"]; then
    if [$2 == true]; then
        if [$2[0] == "."]; then #extention
            for f in *$2; do
                md5raw_new=$(md5sum $f.md5)
                md5_new=(${md5raw_new//\t/ })
                md5raw_old=$(more $f.md5)
                md5_old=(${md5raw_old//\t/ })
                if [md5_new[0] == md5_old[0]]; then
                    echo "$f is OK!"
                else
                    echo "$f ERROR MD5 KEY IS NOT THE SAME!"
                fi
            done
        else
            md5raw_new=$(md5sum $2.md5)
            md5_new=(${md5raw_new//\t/ })
            md5raw_old=$(more $2.md5)
            md5_old=(${md5raw_old//\t/ })
            if [md5_new[0] == md5_old[0]]; then
                echo "$2 is OK!"
            else
                echo "$2 ERROR MD5 KEY IS NOT THE SAME!"
            fi
        fi
    else
        echo -e "ERROR: Filename or Extention argument is missing!"
        echo $usage $sub $ex
        exit 1
    fi
elif ["$1" == "create"]; then
    if [$2 == true]; then
        if [$2[0] == "."]; then
            for f in *$2; do
                md5sum $f > $f.md5
            done
        else
            md5sum $2 > $2.md5
        fi
    else
        echo -e "ERROR: Filename or Extention argument is missing!"
        echo $usage $sub $ex
        exit 1
    fi
else
    echo $usage $sub $ex
fi

