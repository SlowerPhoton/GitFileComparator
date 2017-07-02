#!/bin/bash

# this should be the only line you need to alter
# to specify the file you want to compare across different releases
FILE=crypto/rsa/rsa_gen.c

# directory named DIR will store all the versions of FILE
# their names follow the "<realease_name>.txt" format
DIR=`basename $FILE | sed 's/\([a-zA-Z0-9_]*\).*/\1/'`
if [ ! -d $DIR ]
then
	mkdir $DIR
fi

# download OpenSSL if needed
if [ ! -d openssl ]
then
	git clone https://github.com/openssl/openssl.git
fi
cd openssl
DIR_PATH=../$DIR

# download all versions of FILE file for all tags/releases (no matter the branch)
git tag --sort=taggerdate | while read tag
do
	HASH=`git rev-list -1 $tag`
	WEB_PAGE=https://raw.githubusercontent.com/openssl/openssl/$HASH/$FILE
	FILENAME=$DIR_PATH/${tag}.txt
	GET $WEB_PAGE > $FILENAME
done

# store the results into RESULT file
# it is viewable by Excel-like apps, ';' is the delimeter
# if there is '*' in the second column, then the version differs from the previous one
# branches delimited by an empty row and a header specifying the name of the branch
RESULT=../result_openssl.txt
if [ -f $RESULT ]
then
	rm $RESULT
fi

git branch -r | sed '1d' | while read branch # for each branch
do	
	echo BRANCH\: $branch\; >> $RESULT # header
	git tag --merged $branch --sort=taggerdate | while read tag # for each tag
	do
		echo -n ${tag}\; >> $RESULT
		FILENAME=$DIR_PATH/${tag}.txt
		if [ ! -z ${PREV_FILENAME+x} ] # if variable PREV_FILENAME is set
		then
			if ! diff $PREV_FILENAME $FILENAME > /dev/null
			then
				echo -n \* >> $RESULT
			fi
		fi
		PREV_FILENAME=$FILENAME
		echo "" >> $RESULT 
	done
	echo "" >> $RESULT # empty row
done


