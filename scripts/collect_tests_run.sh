#!/bin/bash

HOME_DIR=".."
REVISIONS_DIR="$HOME_DIR/original_source"

function extractTestNumber() {
	dir=${1}
	fileName=${2}

	#extract tests only if build success
	success=$( grep -F "BUILD SUCCESS" $dir/$fileName )
	if [ -n "$success" ]; then
		totalTests=$(tac $dir/$fileName | grep -m 1 -oP "Tests run: \K\d+" )
		echo "$totalTests"
	else
		echo "fail"
	fi
}

tools=(
	All
	STARTS
	Ekstazi
)

outFiles=(
	mvnRunOutput.txt
	StartsRTSOutput.txt
	EkstaziRTSOutput.txt
)

mkdir $HOME_DIR/result/testCases

cat $HOME_DIR/repositories.txt |
while IFS=" " read -r subN noUse noUse2; do
	testCountFile=$HOME_DIR/result/testCases/$subN.csv
    echo "rev, All, STARTS, Ekstazi" > $testCountFile

    for revIdx in {1..50}; do
		revN="rev_$revIdx"
		for i in ${!tools[*]}; do
			tool=${tools[$i]}
			file=${outFiles[$i]}

			if [[ $tool == All ]]; then
				if [[ $revN == rev* ]] && [ -d $REVISIONS_DIR/$subN/$revN ]; then
                    echo "extract from " $REVISIONS_DIR/$subN
                    returnVal=$(extractTestNumber $REVISIONS_DIR/$subN/$revN $file)
                    countStr+="$returnVal, "
                fi
			else
				if [[ $revN == rev* ]] && [ -d $HOME_DIR/$tool/$subN/$revN ]; then
					echo "extract from " $HOME_DIR/$tool/$subN
					returnVal=$(extractTestNumber $HOME_DIR/$tool/$subN/$revN $file)
					countStr+="$returnVal, "
				fi
			fi
		done

		if [[ ${#countStr} == 0 ]]; then
			echo "$revN: Not Avaiable!"
		else
			echo "$revN, ${countStr::-2}" >> $testCountFile
			countStr=""
		fi
	done
done

# from TOOL/SUB/REV/TOOLRTSoutput, collect tests run
# from original_source/SUB/REV/mvnRunOutput.txt, collect total tests