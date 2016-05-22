#! /bin/bash
txtund=$(tput sgr 0 1)          # Underline
txtbld=$(tput bold)             # Bold
bldred=${txtbld}$(tput setaf 1) #  red
bldblu=${txtbld}$(tput setaf 4) #  blue
bldwht=${txtbld}$(tput setaf 7) #  white
bldgrn=${txtbld}$(tput setaf 2) #  green
txtrst=$(tput sgr0)             # Reset
info=${bldwht}*${txtrst}        # Feedback
pass=${bldblu}*${txtrst}
warn=${bldred}*${txtrst}
ques=${bldblu}?${txtrst}


if [ "$1" = "" ]
    then
        echo $bldblu
        echo Usage: $txtrst name-subtitles "<srt>" "<avi>"
        echo
        echo $bldblu Example: $txtrst name-subtitles S03 3x 
    else
        for (( j=0; j<30; j++ ))
        do
            i=$(printf "%s%.2d" "$1" "$j")
            u=$(printf "%s%.2d" "$2" "$j")
            if [ -a "`ls *.srt|grep $i`" ]
                then
                    mv "`ls *.srt|grep $i`" "`ls *.avi|grep $u|awk -F. -v OFS=. '{$NF=""; sub("[.]$", ""); print}'`.srt"            
            fi
        done
fi