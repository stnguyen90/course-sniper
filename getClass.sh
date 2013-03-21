#/bin/bash

while read file; do

	wget -q -O temp_course "http://www.registrar.ucla.edu/schedule/crsredir.aspx?termsel=11W&subareasel=${file}"

	Subject=$(echo ${file} | sed "s/\+//g" | sed "s/%26//g")

	grep "<option value=" temp_course | sed "s/\t\t\t\t<option value=\"\([^\"]*\)\">\([^-]*\)[^<]*<\/option>/\2=\1/g" | sed "s/^\([:alnum:]*\) *=/\1=/g" | sed "s/.* \([^ ]*\) =/${Subject}\1=/g" | sed "s/ /\+/g" | sed "s/\([^=]*\)=\(........\)/False \"\1\" \"\2\"/g" > ./Courses/Courses_${Subject}

	rm temp_course

done < ./Courses/Subjects
