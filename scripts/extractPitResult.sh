#!/bin/bash

HOME_DIR=".."

tools=(
	STARTS
	Ekstazi
)

function extractMutation() {
	dir=${1}
	fileName=${2}

	#extract tests only if build success
	success=$( grep -F "BUILD SUCCESS" $dir/$fileName )
	if [ -n "$success" ]; then
		percentKilled=$(grep -oP 'Generated \d+ mutations Killed \d+ \(\K\d+(?=%\))' $dir/$fileName)

		echo "$percentKilled"
	else
		echo "-"
	fi
}

mkdir $HOME_DIR/result/mutations

cat $HOME_DIR/repositories.txt |
while IFS=" " read -r subN noUse noUse2; do
    mutFile=$HOME_DIR/result/mutations/$subN.csv
    echo "rev, STARTS, Ekstazi" > $mutFile

    for revIdx in {2..50}; do
        revN="rev_$revIdx"
        for i in ${!tools[*]}; do
            tool=${tools[$i]}
            file="pitestResult.txt"

            if [[ $revN == rev* ]] && [ -d $HOME_DIR/$tool/$subN/$revN/pitestResults/ ]; then
                echo "extract from " $HOME_DIR/$tool/$subN
                returnVal=$(extractMutation $HOME_DIR/$tool/$subN/$revN/pitestResults $file)
                mutStr+="$returnVal, "
            fi
        done

    	if [[ ${#mutStr} == 0 ]]; then
			echo "$revN: Not Avaiable!"
		else
			echo "$revN, ${mutStr::-2}" >> $mutFile
			mutStr=""
		fi
    done
done

# echo $(extractMutation /s/bach/m/under/pmhansen/cs514_rts/soucre_repo/RTS_comparison/STARTS/commonsValidator/rev_1/pitestResults pitestResult.txt)