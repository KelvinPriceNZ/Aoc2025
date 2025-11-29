#!/bin/bash

BASEDIR=$(dirname $0)
cd $BASEDIR

if [[ -z $1 ]]
then
   echo "No day number provided"

   if [[ $(date +'%b') == "Dec" ]] && [[ $(date +'%d') < 13 ]]
   then
      # It's Dec 1st to 12th, during AoC, maybe you just want today
      echo "Enter to accept $(date +'%_d'), ctrl-C to abort"
      read reply
      set $(date +'%_d')
   else
      exit 1
   fi
fi

printf -v day "%02d" $1

[ ! -d $day ] && mkdir -p $day

#cp -p solve.py $day/part1.py
#cp -p solve.py $day/part2.py

./render_md.py $day

FILE="input/${day}/input.txt"
[ ! -d $(dirname $FILE) ] && mkdir -p $(dirname $FILE)

if [ ! -s ./${FILE} ]
then
   echo "Fetching $FILE"
   wget --no-cookies --header "Cookie: session=$(<~/.token)" https://adventofcode.com/$(date +'%Y')/day/$1/input -O ${FILE}
   if [[ $? != 0 ]]
   then
      echo "wget error: $? $!"
      exit 2
   fi
else
   echo "$FILE already exists with data"
fi

head ${FILE}
tail ${FILE}
