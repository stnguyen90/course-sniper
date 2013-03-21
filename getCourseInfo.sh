#!/bin/bash

while true
do
echo "Fetching Data..."

#download necessary pages to scrape
wget -q -O /tmp/CourseSniper_pages "http://www.registrar.ucla.edu/schedule/detselect.aspx?termsel=11W&subareasel=LIFESCI&idxcrs=0003++++" "http://www.registrar.ucla.edu/schedule/detselect.aspx?termsel=11W&subareasel=CHEM&idxcrs=0014BL++"
clear
#| tee >(zenity --progress --pulsate --auto-close --text="Fetching Data...")

#Print Course Data
i=(-1)
while read file; do
	#Go down a line so that the faculty information is on a line by itself
	if [ "${file}" = "IDNumber" ] && [ "${i}" != "0" ]; then
		echo -e -n "\n${file}\t" #| tee -a CourseData
		i=$((${i} - 1))
	#Skip the first line because we want don't want to print a new line on the first line
	elif [ -z "${file}" ] && [ "${i}" = "0" ]; then
		continue
	#Print a new line to separate different sections
	elif [ -z "${file}" ] && [ "$((${i}%14))" = "0" ]; then
		echo -e -n "${file}\t" #| tee -a CourseData
		i=$((${i} - 1))
	#Format Closed red
	elif [ "${file}" = "Closed" ]; then
		echo -e -n "\033[31m${file}\033[0m\t" #| tee -a CourseData
	#Format Open green
	elif [ "${file}" = "Open" ]; then
		echo -e -n "\033[32m\033[1m${file}\033[0m\t" #| tee -a CourseData
	#Format W-List as purple
	elif [ "${file}" = "W-List" ]; then
		echo -e -n "\033[35m\033[1m${file}\033[0m\t" #| tee -a CourseData
	#Print any other data
	else
		echo -e -n "${file}\t" #| tee -a CourseData
	fi

	
	#Print new line for formatting purposes
	i=$((${i}+1))
	if [ "$((${i}%14))" = "0" ]; then
		echo -e -n "\n" #| tee -a CourseData
	fi
done < <(cat /tmp/CourseSniper_pages | grep -e "class=\"fachead\"\|dgdClassDataHeader\|<span id=\".*IDNumber\">\|<span id=\".*Type\">\|<span id=\".*SectionNumber\">\|<span id=\".*Days\">\|<span id=\".*TimeStart\">\|<span id=\".*TimeEnd\">\|<span id=\".*Building\">\|<span id=\".*Room\">\|<span id=\".*Restrict\">\|<span id=\".*EnrollTotal\">\|<span id=\".*EnrollCap\">\|<span id=\".*WaitListTotal\">\|<span id=\".*WaitListCap\">\|<span id=\".*Status\">" | sed "s/<tr class=\"dgdClassDataHeader\">/ID Number\nType\nSec\nDays\nStart\nStop\nBlding\nRoom\nRes't\n#En\nEnCp\n#WL\nWLCp\nStatus/g" | sed "s/<a href=\"subdet.aspx?srs=\([0-90-90-90-90-90-90-90-90-9]*\)[^>]*>Crs Info<\/a>/\1/g" | sed "s/<[^>]*>//g" | sed "s/^\s*//g" | sed "s/&nbsp;&nbsp;&nbsp;/\n/g" | sed "s/\r/\t/g" )

echo -e -n "\nas of $(date)\n"

#Pop-up if course is open/waitlisted
if [[ $(grep -e "W-List\|Open" /tmp/CourseSniper_pages) ]]; then
#	./sendEmail.sh
	zenity --info --text="A course is now open\!"
fi

rm /tmp/CourseSniper_*

read -s -n1 -t 5 -p "Press q to quit" key
echo -n -e "\n"
if [ "$key" = "q" ]; then
	break
fi


done
