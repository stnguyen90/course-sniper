#!/bin/bash

#Global Variables
Links=()
tmpdir=/tmp/CourseSniper
Term=""
mkdir "$tmpdir" || exit 1

function myclean () {
    rm -rf $tmpdir
}

trap myclean EXIT

function selectCourse()
{

	#List of Terms
	wget -q -O "${tmpdir}/schedulehome.aspx" "http://www.registrar.ucla.edu/schedule/schedulehome.aspx" | tee >(zenity --progress --pulsate --auto-close --text="Fetching Data...")

	#Term_Value=( `sed -n '/ctl00$BodyContentPlaceHolder$SOCmain$lstTermDisp/,/<\/select>/p' "${tmpdir}/schedulehome.aspx" | grep option | sed -e 's/^.*value="\([^"]*\)">\([^<]*\).*$/\1/g'` ) #scraping for term values

	Term_arg=`sed -n '/ctl00$BodyContentPlaceHolder$SOCmain$lstTermDisp/,/<\/select>/p' "${tmpdir}/schedulehome.aspx" | grep option | sed -e 's/^.*value="\([^"]*\)">\([^<]*\).*$/FALSE "\2" "\1"/g' | tr '\n' ' ' ` #scraping for terms

#	if [ $(date +%m) -ge 6 ]; then
#		Fall="Fall $(date +%y)"
#		F=$(date +%y)F
#		Winter="Winter $(date --date="next year" +%y)"
#		W=$(date --date="next year" +%y)W
#		Spring="Spring $(date --date="next year" +%y)"
#		S=$(date --date="next year" +%y)S
#	else
#		Fall="Fall $(date --date="last year" +%y)"
#		F=$(date --date="last year" +%y)F
#		Winter="Winter $(date +%y)"
#		W=$(date +%y)W
#		Spring="Spring $(date +%y)"
#		S=$(date +%y)S
#	fi

	
	#Begin Selecting Term
#	if [ "${Term}" == "" ]; then
#		Term=$(zenity  --list  --text "Please choose a Term." --radiolist --print-column=3 --hide-column=3 --column "Choice" --column "Term" --column "Code" FALSE "$Fall" $F FALSE "$Winter" $W FALSE "$Spring" $S)
		Term=$(zenity  --list  --text "Please choose a Term." --radiolist --print-column=3 --hide-column=3 --column "Choice" --column "Term" --column "Code" $Term_arg)
		Term=$(zenity  --list  --text "Please choose a Term." --radiolist --print-column=3 --hide-column=3 --column "Choice" --column "Term" --column "Code" FALSE "Tentative Spring 2012" 12S FALSE "Tentative Winter 2012" 12W FALSE "Fall 2011" 11F FALSE "Summer 2011" 111 FALSE "Spring 2011" 11S FALSE "Winter 2011" 11W)
#	fi

	if [ "${Term}" == "" ]; then
		return
	fi

	#Begin Selecting Subject
	Subject=$(zenity --width=400 --height=400 --list --text "Please Choose a Subject." --radiolist --print-column=3 --hide-column=3 --column "Choice" --column "Subject" --column "Code" \
		False "Aerospace Studies" "AERO+ST" \
		False "African Languages" "AF+LANG" \
		False "African Languages (Pre-Fall 2009)" "AFRICAN" \
		False "African Studies" "AFRC+ST" \
		False "Afrikaans" "AFRKAAN" \
		False "Afro-American Studies" "AFRO-AM" \
		False "American Indian Studies" "AM+IND" \
		False "Ancient Near East" "AN+N+EA" \
		False "Anesthesiology" "ANES" \
		False "Anthropology" "ANTHRO" \
		False "Applied Linguistics" "APPLING" \
		False "Applied Linguistics and Teaching English a..." "AP%26TESL" \
		False "Applied Linguistics (Pre-Fall 2009)" "AP+LING" \
		False "Arabic" "ARABIC" \
		False "Archaeology" "ARCHEOL" \
		False "Architecture and Urban Design" "ARCH%26UD" \
		False "Armenian" "ARMENIA" \
		False "Art" "ART" \
		False "Art History" "ART+HIS" \
		False "Arts and Architecture" "ART%26ARC" \
		False "Asian" "ASIAN" \
		False "Asian American Studies" "ASIA+AM" \
		False "Astronomy" "ASTR" \
		False "Atmospheric and Oceanic Sciences " "A%26O+SCI" \
		False "Berber" "BERBER" \
		False "Bioengineering" "BIOENGR" \
		False "Bioinformatics" "BIOINFO" \
		False "Biological Chemistry" "BIOL+CH" \
		False "Biomathematics" "BIOMATH" \
		False "Biomedical Engineering" "BIOMED" \
		False "Biomedical Physics" "BMEDPHY" \
		False "Biomedical Research" "BMD+RES" \
		False "Biostatistics" "BIOSTAT" \
		False "Bulgarian" "BULGAR" \
		False "Central and East European Studies " "CEE+STD" \
		False "Chemical Engineering" "CH+ENGR" \
		False "Chemistry and Biochemistry" "CHEM" \
		False "Chicana and Chicano Studies" "CHICANO" \
		False "Chinese" "CHIN" \
		False "Civic Engagement" "CIVIC" \
		False "Civil and Environmental Engineering" "C%26EE" \
		False "Classics" "CLASSIC" \
		False "Communication Studies" "COMM+ST" \
		False "Community Health Sciences" "COM+HLT" \
		False "Comparative Literature" "COM+LIT" \
		False "Computational and Systems Biology" "C%26S+BIO" \
		False "Computer Science" "COM+SCI" \
		False "Conservation of Archaeological Ethnographi..." "CAEM" \
		False "Czech" "CZECH" \
		False "Dance" "DANCE" \
		False "Dentistry" "DENT" \
		False "Design | Media Arts" "DESMA" \
		False "Disability Studies" "DIS+STD" \
		False "Dutch" "DUTCH" \
		False "Earth and Space Sciences" "E%26S+SCI" \
		False "East Asian Studies" "E+A+STD" \
		False "Ecology and Evolutionary Biology " "EE+BIOL" \
		False "Economics" "ECON" \
		False "Education" "EDUC" \
		False "Electrical Engineering" "EL+ENGR" \
		False "Engineering" "ENGR" \
		False "English" "ENGL" \
		False "English as a Second Language" "ESL" \
		False "English Composition" "ENGCOMP" \
		False "Environment" "ENVIRON" \
		False "Environmental Health Sciences" "ENV+HLT" \
		False "Environmental Science and Engineering" "ENV+SCI" \
		False "Epidemiology" "EPIDEM" \
		False "Ethnomusicology" "ETHNOMU" \
		False "European Studies" "EURO+ST" \
		False "Family Medicine" "FAM+MED" \
		False "Filipino" "FILIPNO" \
		False "Film and Television" "FILM+TV" \
		False "French" "FRNCH" \
		False "General Education Clusters" "GE+CLST" \
		False "Geography" "GEOG" \
		False "Geriatrics" "GERIATR" \
		False "German" "GERMAN" \
		False "Gerontology" "GRNTLGY" \
		False "Global Studies" "GLBL+ST" \
		False "Greek" "GREEK" \
		False "Health Services" "HLT+SER" \
		False "Hebrew" "HEBREW" \
		False "Hindi-Urdu" "HIN-URD" \
		False "History" "HIST" \
		False "Honors Collegium" "HNRS" \
		False "Human Complex Systems" "HUM+CS" \
		False "Human Genetics" "HUM+GEN" \
		False "Hungarian" "HUNGRN" \
		False "Indigenous Languages of the Americas (pre-..." "ILA" \
		False "Indo-European Studies" "I+E+STD" \
		False "Indonesian" "INDO" \
		False "Information Studies" "INF+STD" \
		False "International Development Studies" "INTL+DV" \
		False "Iranian" "IRANIAN" \
		False "Islamics" "ISLAMIC" \
		False "Islamic Studies" "ISLM+ST" \
		False "Italian" "ITALIAN" \
		False "Japanese" "JAPAN" \
		False "Jewish Studies" "JEWISH" \
		False "Korean" "KOREA" \
		False "Labor and Workplace Studies" "LBR%26WS" \
		False "Latin" "LATIN" \
		False "Latin American Studies" "LATN+AM" \
		False "Law" "LAW" \
		False "Law, Undergraduate" "UG-LAW" \
		False "Lesbian, Gay, Bisexual, and Transgender St..." "LGBTS" \
		False "Life Sciences" "LIFESCI" \
		False "Linguistics" "LING" \
		False "Lithuanian" "LITHUAN" \
		False "Management" "MGMT" \
		False "Materials Science and Engineering" "MAT+SCI" \
		False "Mathematics" "MATH" \
		False "Mechanical and Aerospace Engineering" "MECH%26AE" \
		False "Medical History" "MED+HIS" \
		False "Medicine" "MED" \
		False "Microbiology, Immunology, and Molecular Ge..." "MIMG" \
		False "Middle Eastern and North African Studies" "MENAS" \
		False "Military Science" "MIL+SCI" \
		False "Molecular and Medical Pharmacology" "M+PHARM" \
		False "Molecular Biology" "MOL+BIO" \
		False "Molecular, Cell, and Developmental Biology" "MCD+BIO" \
		False "Molecular, Cellular, and Integrative Physi..." "MC%26IP" \
		False "Molecular Toxicology" "MOL+TOX" \
		False "Moving Image Archive Studies" "MIA+STD"\
		False "Music" "MUSIC" \
		False "Music History" "MUS+HST" \
		False "Musicology" "MUSCLGY" \
		False "Naval Science" "NAV+SCI" \
		False "Near Eastern LaPress OK to continue and CANCEL when done.nguages" "NR+EAST" \
		False "Neurobiology" "NEURBIO" \
		False "Neurology" "NEURLGY" \
		False "Neuroscience" "NEUROSC" \
		False "Neuroscience (Graduate)" "NEURO" \
		False "Neurosurgery" "NEURSGY" \
		False "Nursing" "NURSING" \
		False "Obstetrics and Gynecology" "OBGYN" \
		False "Old Norse" "NORSE" \
		False "Opthalmology" "OPTH" \
		False "Oral Biology" "ORL+BIO" \
		False "Orthopaedic Surgery" "ORTHPDC" \
		False "Pathology and Laboratory Medicine" "PATH" \
		False "Pediatrics" "PEDS" \
		False "Philosophy" "PHILOS" \
		False "Physics" "PHYSICS" \
		False "Physiological Science" "PHYSCI" \
		False "Physiological Science (Pre-Fall 2010)" "PHY+SCI" \
		False "Physiology" "PHYSIOL" \
		False "Polish" "POLISH" \
		False "Political Science" "POL+SCI" \
		False "Portuguese" "PORTGSE" \
		False "Program in Computing" "COMPTNG" \
		False "Psychiatry and Biobehavioral Sciences" "PSYCTRY" \
		False "Psychology" "PSYCH" \
		False "Public Health" "PUB+HLT" \
		False "Public Policy" "PUB+PLC" \
		False "Quechua" "QUECHUA" \
		False "Radiation Oncology" "RAD+ONC" \
		False "Religion, Study of" "RELIGN" \
		False "Romanian" "ROMAN" \
		False "Russian" "RUSSIAN" \
		False "Scandinavian" "SCAND" \
		False "Semitics" "SEMITIC" \
		False "Serbian/Croatian" "SER+CRO" \
		False "Slavic" "SLAVIC" \
		False "Social Thought" "SOC+THT" \
		False "Social Welfare" "SOC+WLF" \
		False "Society and Genetics" "SOC+GEN" \
		False "Sociology" "SOCIOL" \
		False "South Asian" "S+ASIAN" \
		False "Southeast Asian" "SEASIAN" \
		False "Southeast Asian Studies" "SE+A+ST" \
		False "Spanish" "SPAN" \
		False "Statistics" "STATS" \
		False "Surgery" "SURGERY" \
		False "Thai" "THAI" \
		False "Theater" "THEATER" \
		False "Turkic Languages" "TURKIC" \
		False "Ukrainian" "UKRAIN" \
		False "Urban Planning" "URBN+PL" \
		False "Urology" "UROLOGY" \
		False "Vietnamese" "VIETMSE" \
		False "Women's Studies" "WOM+STD" \
		False "World Arts and Cultures" "WLD+ART" \
		False "Yiddish" "YIDDSH")

	if [ "${Subject}" == "" ]; then
		return
	fi

	#Begin Selecting Course
	shortSub=$(echo ${Subject} | sed "s/\+/ /g" | sed "s/%26/ & /g")

	wget -q -O "${tmpdir}/temp_course_page" "http://www.registrar.ucla.edu/schedule/crsredir.aspx?termsel=${Term}&subareasel=${Subject}" | tee >(zenity --progress --pulsate --auto-close --text="Fetching Data...")

	CoursesList=()
	while read -d $'.'; do
		CoursesList+=("$REPLY")
	done < <(grep "<option value=" "${tmpdir}/temp_course_page" | sed -e "s/\(value=\"....\) /\1+/g" -e "s/\(value=\".....\) /\1+/g" -e "s/\(value=\"......\) /\1+/g" -e "s/\(value=\".......\) /\1+/g" | sed "s/\t\t\t\t<option value=\"\([^\"]*\)\">/\1=/g" | sed "s/\([^=]*\)=\([^<]*\)<\/option>/False.\2.\1./g" | sed "s/[\n\r]//g")

	Course=$(zenity --width=400 --height=400 --list --text "Please Choose a Course." --radiolist --print-column=3 --hide-column=3 --column "Choice" --column "Subject" --column "Code" "${CoursesList[@]}")

	if [ "${Course}" == "" ]; then
		return
	fi

	Links+=("http://www.registrar.ucla.edu/schedule/detselect.aspx?termsel=${Term}&subareasel=${Subject}&idxcrs=${Course}")

	return
}

function getCourseInfo()
{
	echo "Fetching Data..."
	wget -q -O "${tmpdir}/CourseSniper_pages" "${Links[@]}" #| tee >(zenity --progress --pulsate --auto-close --text="Fetching Data...")
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
			echo -e -n "${file}\t" | tee -a CourseData
			i=$((${i} - 1))
		#Format Closed red
		elif [ "${file}" = "Closed" ]; then
			echo -e -n "\033[31m${file}\033[0m\t" | tee -a "${tmpdir}/CourseData"
		#Format Open green
		elif [ "${file}" = "Open" ]; then
			echo -e -n "\033[32m\033[1m${file}\033[0m\t" | tee -a "${tmpdir}/CourseData"
		#Format W-List as purple
		elif [ "${file}" = "W-List" ]; then
			echo -e -n "\033[35m\033[1m${file}\033[0m\t" | tee -a "${tmpdir}/CourseData"
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

	echo -e -n "\nas of $(date)\n"

	#Send email and Pop-up if course is open/waitlisted
	grep -e "W-List\|Open" "${tmpdir}/CourseData"
	grep_status=$?
	diff -q "${tmpdir}/CourseData" "${tmpdir}/CourseData_old" 2> /dev/null
	diff_status=$?
	if [[ "${grep_status}" == "0" ]] && [[ "${diff_status}" != "0" ]]; then
		#TODO: implement emailing
		#sendEmail -q -f EMAIL:FROM -t EMAIL:TO \
		#-u A course is now open! -m “$(grep  -e "Open" "${tmpdir}/CourseData")” \
		#-s smtp.gmail.com \
		#-o tls=yes \
		#-xu USERNAME -xp PASSWORD
		zenity --info --text="A course is now open\!"
		
	fi
	mv "${tmpdir}/CourseData" "${tmpdir}/CourseData_old"
}

while true
do
	selectCourse
	zenity --question --text "Done selecting which courses you want to snipe?"

	if [ "$?" == "0" ]; then
		break
	fi
	
done

while true
do
	clear
	getCourseInfo
	read -s -n1 -t 5 -p "Press q to quit" key
	echo -n -e "\n"
	if [ "$key" = "q" ]; then
		break
	fi

done

