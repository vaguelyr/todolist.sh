#!/bin/bash
# vague
# 'some people can make do with just a list of stuff they need to do'

# color reference
# https://misc.flogisoft.com/bash/tip_colors_and_formatting

# colors
nc='\033[0m'
color_array[0]='\033[0m' 	# none
color_array[1]='\033[0;30m' 	# black
color_array[2]='\033[1;30m' 	# dgrey
color_array[3]='\033[0;31m' 	# red
color_array[4]='\033[1;31m' 	# lred
color_array[5]='\033[0;32m' 	# green
color_array[6]='\033[1;32m' 	# lgreen
color_array[7]='\033[0;33m' 	# brown
color_array[8]='\033[1;33m' 	# yellow
color_array[9]='\033[0;34m'	# blue
color_array[10]='\033[1;34m'  	# lblue
color_array[11]='\033[0;35m'  	# purple
color_array[12]='\033[38;5;127m' # lpurple
color_array[12]='\033[1;35m' 	# lpurple
color_array[13]='\033[0;36m'    # cyan
color_array[14]='\033[1;36m'    # lcyan
color_array[15]='\033[0;37m'    # lgrey
color_array[16]='\033[1;37m'    # white
color_array[17]='\033[38;5;239' # birthdays
color_array[18]='\033[38;5;69m' # hw
color_array[19]='\033[38;5;30m' # fainter cyan

# priorities
priority[0]="${color_array[4]}" # tests
priority[1]="${color_array[18]}" # homework 
priority[2]="${color_array[8]}" # life stuff? 
priority[3]="${color_array[0]}" # birthdays 
priority[4]="${color_array[2]}" # academics 

# functions
todoWrite(){
	ds=$(date -d "$1" +"%s")
	#ds=${color_array[6]}$ds${color_array[0]}

	# colors
	# check if the 3rd arg is a number and then set the color
	echo $3 | grep -P "[0-9]{1,2}" >/dev/null && {
		if [ "$3" -gt 4 ] ; then
			linecolor="${color_array[$3]}"
		else
			linecolor="${priority[$3]}"
		fi

		# delete the 3rd element since its a color number
		# and add the rest of the line to the msg
		msg=\"${@:2:1}\ ${@:4}\"
	} || {
		linecolor=""
		# add the rest of the line to the msg
		msg=\"${@:2}\" 
	}
	if [ ! "$sectionColorOverride" = "" ];then
		#echo $sectionColorOverride is
		linecolor="\033[${color_array[$sectionColorOverride]}m"
	fi
		
	# csv cant handle nested commas
	msg=$(echo $msg | sed -e 's/,/./g' ) 

	# write to screen 
	echo -e $ds,${linecolor}$msg${nc}

	# write to txt
	echo -e $ds,${linecolor}$msg${nc} >> $logfile
}
todoDisplay(){
	now=$(date +%s)
	echo todoDisplay now is $now $(date +%c)
	sort -nr $logfile | while read line ; do
		ds=$(echo $line | cut -d "," -f 1)
		msg=$(echo $line | cut -d "," -f 2 | sed -e 's/\"//g')
		
		# write to csv
		echo -e "\"$ds\",$msg" >> $csvfile

		# skip past events
		if [ "$ds" -lt "$now" ]; then
			#echo skip $msg
			continue
		fi

		# write to screen 
		date_display_prefix=$(date -d @$ds +"[%c]" )
		echo "$date_display_prefix $msg"

	done
}

# options 
logfile='./todo.txt'
csvfile='./todo.csv'

# start
rm $logfile
rm $csvfile

# =============================== priority test
todoWrite "feb 01 2035 12:00:00" "color" 0 0
todoWrite "feb 02 2035 12:00:00" "color" 1 1
todoWrite "feb 03 2035 12:00:00" "color" 2 2
todoWrite "feb 04 2035 12:00:00" "color" 3 3
todoWrite "feb 05 2035 12:00:00" "color" 4 4 
# =============================== color test
todoWrite "feb 06 2035 12:00:00" "color" 5 5 
todoWrite "feb 07 2035 12:00:00" "color" 6 6
todoWrite "feb 08 2035 12:00:00" "color" 7 7 
todoWrite "feb 09 2035 12:00:00" "color" 8 8 
todoWrite "feb 10 2035 12:00:00" "color" 9 9
todoWrite "feb 11 2035 12:00:00" "color" 10 10
todoWrite "feb 12 2035 12:00:00" "color" 11 11
todoWrite "feb 13 2035 12:00:00" "color" 12 12
todoWrite "feb 14 2035 12:00:00" "color" 13 13
todoWrite "feb 15 2035 12:00:00" "color" 14 14 
todoWrite "feb 16 2035 12:00:00" "color" 15 15
todoWrite "feb 17 2035 12:00:00" "color" 16 16
# =============================== birthdays
sectionColorOverride=17
todoWrite "feb 06  12:00:00" "birthday person name" 
todoWrite "feb 12  12:00:00" "birthday person name" 
todoWrite "mar 31  12:00:00" "birthday person name"  
todoWrite "aug 08  12:00:00" "birthday person name"  
todoWrite "sep 05  12:00:00" "birthday person name"  
todoWrite "oct 06  12:00:00" "birthday person name" 
todoWrite "nov 23  12:00:00" "birthday person name"  
todoWrite "dec 18  12:00:00" "birthday person name" 
sectionColorOverride=""
# =============================== academic

todoDisplay
