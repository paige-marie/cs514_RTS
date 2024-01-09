#!/bin/env bash

HOME_DIR="/s/bach/h/proj/ghosh/pmhansen/rts/RTS_comparison"
ORGINAL_DIR=$HOME_DIR"/original_source/commonsValidator"
for fullPath in $ORGINAL_DIR/rev_*; do
    revN=$(basename "$fullPath")
    cd $ORGINAL_DIR"/$revN"
    echo ---------------------------------------------------------------------------------validator $revN
    mvn -Drat.ignoreErrors=true test > mvnRunOutput.txt
done

ORGINAL_DIR=$HOME_DIR"/original_source/commonsImaging"
for fullPath in $ORGINAL_DIR/rev_*; do
    revN=$(basename "$fullPath")
    cd $ORGINAL_DIR"/$revN"
    echo ---------------------------------------------------------------------------------imaging $revN
    mvn -Drat.ignoreErrors=true test > mvnRunOutput.txt
done

ORGINAL_DIR=$HOME_DIR"/original_source/asterisk"
for fullPath in $ORGINAL_DIR/rev_*; do
    revN=$(basename "$fullPath")
    cd $ORGINAL_DIR"/$revN"
    echo ---------------------------------------------------------------------------------asterisk $revN
    mvn -Drat.ignoreErrors=true test > mvnRunOutput.txt
done