#!/bin/bash

usage="Usage: $0 [subcommand] [filename or extension]\n"
sub="\nsubcommand:\n$0 test [filename or extension]\n$0 create [filename or extension]\n"
ex="\nexample:\n$0 create .gz"

if [ "$#" -lt 2 ]; then
    echo -e "ERROR: Filename or Extension argument is missing!"
    echo -e "$usage$sub$ex"
    exit 1
fi

if [ "$1" == "test" ]; then
    if [ -n "$2" ]; then
        if [ "$2" == .* ]; then #extention
            for f in *"$2"; do
                if [[ -f "$f.md5" ]]; then
                    md5raw_new=$(md5sum $f.md5)
                    md5_new=(${md5raw_new//\t/ })
                    md5raw_old=$(more $f.md5)
                    md5_old=(${md5raw_old//\t/ })

                    if [[ "${md5_new[0]}" == "${md5_old[0]}" ]]; then
                        echo -e "$f is OK!"
                    else
                        echo -e "$f ERROR: MD5 checksum does not match!"
                    fi
                else
                    echo -e "WARNING: No MD5 checksum found for $f"
                fi
            done
        else # filename
            if [[ -f "$2.md5" ]]; then
                md5raw_new=$(md5sum $2.md5)
                md5_new=(${md5raw_new//\t/ })
                md5raw_old=$(more $2.md5)
                md5_old=(${md5raw_old//\t/ })
                if [ md5_new[0] == md5_old[0] ]; then
                    echo -e "$2 is OK!"
                else
                    echo -e "$2 ERROR MD5 KEY IS NOT THE SAME!"
                fi
            else
                echo -e "ERROR: No MD5 checksum file found for $2"
            fi
        fi
    else
        echo -e "ERROR: Filename or Extention argument is missing!"
        echo -e "$usage$sub$ex"
        exit 1
    fi

elif [ "$1" == "create" ]; then
    if [ -n "$2" ]; then
        for f in "*$2"; do
            if [ -f "$f" ]; then
                md5sum "$f" > "$f.md5"
                echo -e "MD5 checksum created for $f"
            fi
        done
    else
        if [ -f "$f" ]; then
            md5sum $2 > $2.md5
            echo -e "MD5 checksum created for $2"
        
        else
            echo -e "ERROR: File $2 does not exist!"
        fi
    fi

else
    echo -e "ERROR: Filename or Extention argument is missing!"
    echo -e "$usage$sub$ex"
    exit 1
fi

