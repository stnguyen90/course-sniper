#/bin/bash

wget -q -O temp_subject "http://www.registrar.ucla.edu/schedule/schedulehome.aspx"

grep "<option value=" temp_subject | sed "s/	<option value=\"\([^\"]*\)\">\([^<]*\)<\/option>/False \"\2\" \"\1\"/g" | sed "s/\(False \"[^\"]*\" \"[^ ]*\) /\1\+/g" | sed "s/\(False \"[^\"]*\" \"[^ ]*\) /\1\+/g" | sed "s/\(False \"[^\"]*\" \"[^ ]*\) /\1\+/g" | sed "s/&amp;/%26/g" | sed "s/[\r\n]//g" > Subjects

while read file; do
	echo -n "${file} "
done < Subjects


