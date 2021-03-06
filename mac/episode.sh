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

SAVEIFS=$IFS
IFS=$(echo -en "\n\b")


#if [ "$1" = "" ]
#    then
#        echo $bldblu
#        echo Usage: $txtrst name-subtitles "<srt>" "<avi>"
#        echo
#        echo $bldblu Example: $txtrst name-subtitles S03 3x 
#    else

for FILE in $(ls *.avi *.mkv)
do
    FILECS=$(echo $FILE|sed 's/.avi/.srt/g'|sed 's/.mkv/.srt/g')
    FILE=$(echo $FILE|tr [a-z] [A-Z])
    SEASON=$(echo $FILE | grep -oh "S[0-9]\+E" | tr -d "SE")
    EPISODE=$(echo $FILE | grep -oh "S[0-9]\+E[0-9]\+" | grep -oh "E[0-9]\+" | tr -d Ee)
    #formato S??E??
    
    if [ -z "$SEASON" ]
    then
        SEASON=$(echo $FILE | grep -oh "[0-9]\+X" | tr -d "xX")
        EPISODE=$(echo $FILE | grep -oh "[0-9]\+X[0-9]\+" | grep -oh "X[0-9]\+" | tr -d Xx)
        FORMATX=$SEASON"X"$EPISODE
        #formato ??x??
    fi
    
    if [ -z "$SEASON" ] 
        then
            echo $bldred Non episode avi file! $FILE $txtrst
        else
            SEASON=$(printf "%.2d" "${SEASON#0}")
            SEASONONE=$(printf "%d" "${SEASON#0}")
            EPISODE=$(printf "%.2d" "${EPISODE#0}")
            EPISODEONE=$(printf "%d" "${EPISODE#0}")
            FORMATX=$SEASON"X"$EPISODE
            FORMATXONE=$SEASONONE"X"$EPISODE
            FORMATXONEONE=$SEASONONE"X"$EPISODEONE
            FORMATS="S"$SEASON"E"$EPISODE
            FORMATSONE="S"$SEASONONE"E"$EPISODE
            FORMATSONEONE="S"$SEASONONE"E"$EPISODEONE
            echo " "
            echo $txtbld Found avi/mkv file: $bldblu $FILE $bldgrn Season:$SEASON Episode:$EPISODE $txtrst

            #Search for corresponding srt file
            SRTFILE=$(ls *.srt|grep -i $FORMATX)
            if [ -z "$SRTFILE" ]
            then
                SRTFILE=$(ls *.srt|grep -i $FORMATS)
            fi
            if [ -z "$SRTFILE" ]
            then
                SRTFILE=$(ls *.srt|grep -i $FORMATX)
            fi
            if [ -z "$SRTFILE" ]
            then
                SRTFILE=$(ls *.srt|grep -i $FORMATXONE)
            fi
            if [ -z "$SRTFILE" ]
            then
                SRTFILE=$(ls *.srt|grep -i $FORMATXONEONE)
            fi
            if [ -z "$SRTFILE" ]
            then
                SRTFILE=$(ls *.srt|grep -i $FORMATSONE)
            fi
            if [ -z "$SRTFILE" ]
            then
                SRTFILE=$(ls *.srt|grep -i $FORMATSONEONE)
            fi
            if [ -z "$SRTFILE" ]
            then
                echo $bldred No subtitle file found corresponding to $FILE $txtrst
            else
                if [ -e "$SRTFILE" ]
                then
                    mv $SRTFILE $FILECS
                    echo $txtbld Srt file renamed:  $bldblu   $SRTFILE $bldgrn "->" $bldblu $FILECS $txtrst
  
                else
                    echo $bldred Subtitle file error, maybe multiple files: $bldblu $SRTFILE $txtrst
                fi
            fi
        fi
done
IFS=$SAVEIFS

