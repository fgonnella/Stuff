#! /bin/bash
touch jbi.tmp
rm jbi.tmp
jbi -i $1 >> jbi.tmp
JBI=$(cat jbi.tmp | grep "NOTE \"IDCODE\" = " | tr -d ,|tr -d \" )
JBI=$(echo $JBI|awk 'BEGIN { FS = " = " } ; { print $2 }')
JTAG=$(jtagscan|grep Device|awk '{print $4}'|tr [:lower:] [:upper:])
NJTAG=$(echo $JTAG|wc -w)
NJBI=$(echo $JBI|wc -w)
FILES=$(cat jbi.tmp | grep "NOTE \"FILE\" = " | tr -d \" |tr -d , )
FILES=$(echo $FILES|awk 'BEGIN { FS = " = " } ; { print $2 }')      



NJBI=$(echo $NJBI | bc)

if [ "$NJBI" -eq "$NJTAG" ]
then
	
	echo $NJBI devices found.
	COUNT=0

	for ID in $JTAG
	do
		
		A=$(echo $JBI|awk -v colonna=$NJBI '{print $colonna}')
		A=$(echo "ibase=16; $A"| bc)
		NJBI=$(echo $NJBI - 1|bc)
		B=$(echo "ibase=16; $ID"| bc)
	if  [ "$A" -eq "$B" ]
	then
		COUNT=$(echo $COUNT + 1| bc)
		echo device $COUNT matches!

	fi
	done

	if [ "$COUNT" -eq "$NJTAG" ]
	then
	 echo "All devices match!"
	 echo "_________________"
	 echo " "
	

	 DEVICE=0
	 for NAME in $FILES
	 do
	     if [ "$NAME" = "NOTE" ]
	     then
		 break
	     fi
	     

	     if [ "$NAME" = "-" ]
	     then
		 DEVICE=$(echo $DEVICE + 1| bc)
	     else
		 FILE_NAME=$NAME
		 break
	     fi
	 done
#
  FILE_TYPE=$(echo $FILE_NAME|awk 'BEGIN { FS = "." } ; { print $2 }')

#  echo $DEVICE
#  echo $FILE_NAME
#  echo $FILE_TYPE

# 	 echo "Program device with $1 ?"
#	 echo "(yes/no)"
#	 read YESNO
#	 YESNO=$(echo $YESNO|tr [:upper:] [:lower:])
#	 if [ "$YESNO" == "yes" ]
#	     then

if [ "$DEVICE" -eq "4" ]
then
    FPGA="PP"
fi

if [ "$DEVICE" -eq "0" ]
then
    FPGA="SL"
fi

if [ "$DEVICE" -ge "9" ]
then
    FPGA=$(echo TDCBs)
fi



  if [ "$FILE_TYPE" = "jic" ]
  then
      echo Programming jic file: $FILE_NAME into $FPGA...
      jbi -aPROGRAM -n3 -w1 $1
  fi
  
  if [ "$FILE_TYPE" = "sof" ]
  then
      echo Programming sof file: $FILE_NAME into $FPGA...   	  
      jbi -aCONFIGURE -n3 -w1 $1    
  fi


	else
	  echo "Device type mismatch !!"
	fi

else
	echo "Number of devices mismatch!"
fi

