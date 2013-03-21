#!/bin/bash

#Global Variables
email=$1
Links=( ${@:2} )
tmpdir=/tmp/CourseSniper-`echo $1 | sed -e 's/\(^[^@]*\).*$/\1/g'`
Term=""

function myclean () {
	#read -s -n1 -p "Press q to quit" key
	rm -rf $tmpdir
}

trap myclean EXIT

function getCourseInfo()
{
	echo "Fetching Data..."
	curl -s ${Links[@]} > "${tmpdir}/CourseSniper_pages" #| tee >(zenity --progress --pulsate --auto-close --text="Fetching Data...")
	#clear
	

	#Print Course Data
	i=(-1)
	h=(0)
	while read file; do
		if [ $i -eq -1 ]; then
			Head="${file}"
			i=$((${i}+1))
		fi
		
		if [ "${file}" == "${Head}" ]; then
			h=(1)
		fi

		if [ $h -gt 0 ]; then
			if [ $h -eq 1 ]; then
				if [ $i -gt 0 ]; then
					echo -e "\n" | tee -a "${tmpdir}/CourseData"
				fi
				echo -e "${file}" | tee -a "${tmpdir}/CourseData" 	#print Term
			elif [ $h -eq 3 ]; then
				echo -e "${file}" | tee -a "${tmpdir}/CourseData"	#print Course
			fi
				 
			
			
			if [ $h -eq 3 ]; then
				h=(0)
			else
				h=$((${h}+1))
			fi
			continue
		fi

		#Go down a line so that the faculty information is on a line by itself
		if [ "${file}" = "ID Number" ]; then
			echo -e -n "\n${file}\t" | tee -a "${tmpdir}/CourseData"
			i=0
		#Skip the first line because we want don't want to print a new line on the first line
		elif [ -z "${file}" ] && [ "${i}" = "0" ]; then
			continue
		#Print a new line to separate different sections
		elif [ -z "${file}" ] && [ "$((${i}%14))" = "0" ]; then
			echo -e -n "${file}\t" | tee -a "${tmpdir}/CourseData"
			i=$((${i} - 1))
		#Format Closed red
		elif [ "${file}" = "Closed" ]; then
			echo -e -n "<span style=\"color:red;font-weight:bold;\">${file}</span>\t" | tee -a "${tmpdir}/CourseData"
		#Format Open green
		elif [ "${file}" = "Open" ]; then
			echo -e -n "<span style=\"color:green;font-weight:bold;\">${file}</span>\t" | tee -a "${tmpdir}/CourseData"
		#Format W-List as purple
		elif [ "${file}" = "W-List" ]; then
			echo -e -n "<span style=\"color:purple;font-weight:bold;\">${file}</span>\t" | tee -a "${tmpdir}/CourseData"
		#Print any other data
		else
			echo -e -n "${file}\t" | tee -a "${tmpdir}/CourseData"
		fi

	
		#Print new line for formatting purposes
		i=$((${i}+1))
		if [ "$((${i}%14))" = "0" ]; then
			echo -e -n "\n" | tee -a "${tmpdir}/CourseData"
		fi
	done < <(cat "${tmpdir}/CourseSniper_pages" | grep -e "class=\"heading2\">\|class=\"coursehead\">\|class=\"fachead\"\|dgdClassDataHeader\|<span id=\".*IDNumber\">\|<span id=\".*Type\">\|<span id=\".*SectionNumber\">\|<span id=\".*Days\">\|<span id=\".*TimeStart\">\|<span id=\".*TimeEnd\">\|<span id=\".*Building\">\|<span id=\".*Room\">\|<span id=\".*Restrict\">\|<span id=\".*EnrollTotal\">\|<span id=\".*EnrollCap\">\|<span id=\".*WaitListTotal\">\|<span id=\".*WaitListCap\">\|<span id=\".*Status\">" | sed "s/<tr class=\"dgdClassDataHeader\">/ID Number\nType\nSec\nDays\nStart\nStop\nBlding\nRoom\nRes't\n#En\nEnCp\n#WL\nWLCp\nStatus/g" | sed "s/<a href=\"subdet.aspx?srs=\([0-90-90-90-90-90-90-90-90-9]*\)[^>]*>Crs Info<\/a>/\1/g" | sed "s/<[^>]*>//g" | sed "s/^\s*//g" | sed "s/&nbsp;&nbsp;&nbsp;/\n/g" | sed "s/\r/\t/g" )

	echo -e -n "\nas of $(date)\n" | tee -a "${tmpdir}/CourseData"

	#Send email and Pop-up if course is open/waitlisted
	status=`grep -e "W-List\|Open" "${tmpdir}/CourseData"`
	grep_status=$?
	if [[ "${grep_status}" == "0" ]]; then
		echo "<table>
		`# print the file with newline and tab indicators
		cat -vT "${tmpdir}/CourseData" | \
		# add opening tr td to beginning of each line
		sed -e 's/^/<tr><td>/g' | \
		# add closing td tr to end of each line
		sed -e 's/$/<\/td><\/tr>/g' | \
		# replace tab with cells
		sed -e 's/\^I/<\/td><td>/g'`
		</table>" |
		# send mail
		mail -a "MIME-Version: 1.0" -a "Content-Type: text/html" -a "Content-Disposition: inline" -s "`awk 'NR == 2' ${tmpdir}/CourseData` is Now $status!" $email
	fi
}
	mkdir "$tmpdir" || exit 1
	getCourseInfo

