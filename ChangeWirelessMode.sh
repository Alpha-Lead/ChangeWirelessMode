#!/bin/bash

## Detect & list connected wireless cards and their interface modes; 
## then change the mode to one selected by user from detected modes
## Author: evail.aj2010@gmail.com

#Scan for avaliable wireless cards
echo "Scanning for avaliable wireless cards:"
avaliable_card=$(ifconfig -a | egrep -o '^w\w*\b')
printf "\033[0;31m" #change font RED
echo  $avaliable_card
printf "\033[0m"	#change font DEFAULT

#Display list of detected wireless cards
echo "Please select the wireless card from the list below:"
select selected_card in $avaliable_card NONE
do
	#Exit if NONE is selected
	if [ "$selected_card" = "NONE" ]
	then
		#Free local variables
		unset avaliable_card
		unset selected_card
		exit 0
	fi
	
	#Exit 'do-loop'
	break
done
echo "Selected wireless card: $selected_card"
echo

#Scan for avaliable interface modes
echo "Scanning for avaliable interface modes:"
wiphyVAR=$(iw dev $selected_card info | grep -oP '(?<=wiphy )[0-9]+') #get iw info sor selected card, find digit for phy reference
avaliable_mode=$(iw list | sed -n '/phy'$wiphyVAR'/,$p' | sed '1,/Supported interface modes:/d;/Band 1:/,$d' | sed -n -e 's/^.* //p') #run iw list -> Cut to after phy# -> cut modes from between "Supported inerface modes:" and "Band 1:" -> cut out "* " from before modes
printf "\033[0;31m" #change font RED
echo  $avaliable_mode
printf "\033[0m"	#change font DEFAULT

#Display list of detected interface modes
echo "Please select the wireless card from the list below:"
select selected_mode in $avaliable_mode NONE
do
	#Exit if NONE is selected
	if [ "$selected_mode" = "NONE" ]
	then
		#Free local variables
		unset avaliable_card
		unset selected_card
		unset avaliable_mode
		unset selected_mode
		unset wiphyVAR
		exit 0
	fi
	
	#Exit 'do-loop'
	break
done
echo "Selected interface mode: $selected_mode"
echo

#Change link state of selected card to 'down'
ifconfig $selected_card down

if [ "$?" -eq "0" ]
then
	echo "Card $selected_card link state changed to: down"
fi

#Change the mode of the selected card
iwconfig $selected_card mode $selected_mode

if [ "$?" -eq "0" ]
then
	echo "Card $selected_card mode changed to: $selected_mode"
fi

#Change link state of selected card to 'up'
ifconfig $selected_card up

if [ "${?}" -eq "0" ]
then
	echo "Card $selected_card link state changed to: up"
fi


#Free local variables
unset avaliable_card
unset selected_card
unset avaliable_mode
unset selected_mode
unset wiphyVAR


#closeout
echo
echo "END OF SCRIPT"
echo

