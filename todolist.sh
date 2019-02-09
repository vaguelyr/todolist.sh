#!/bin/bash
# vague
# 'some people can make do with just a list of stuff they need to do'

# functions
todoWrite(){
	ds=$(date -d "$1" +"%s")

	# this can handle the todoWrite line's message
	# not having quotes
	msg=\"${@:2}\" 
	msg=$(echo $msg | sed -e 's/,/./' ) # csv cant handle nested commas

	# write to screen 
	echo $ds,$msg 

	# write to txt
	echo $ds,$msg >> $logfile

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

# =============================== birthdays
todoWrite "dec 18 2019 12:00:00" "birthday name"
# =============================== academic
# academic
todoWrite "apr 26 2019 12:00:00" "academic last day of classes"
# sports <- this affects parking
todoWrite "mar 24 2019 12:00:00" "academic sports thing"
# =============================== plc lab
# plcsarefun
# =============================== physics
todoWrite "mar 01 2019 22:59:00" "phys2110 thing"
# =============================== os
todoWrite "feb 04 2019 23:59:00" "csc4100 thing"
# =============================== professional issues
todoWrite "feb 04 2019 23:59:00" "ece3920 thing"
# =============================== math
todoWrite "feb 07 2019 08:00:00" "math3470 thing"



todoDisplay
