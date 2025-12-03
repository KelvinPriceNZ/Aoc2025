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

[[ ! -d src/day${day} ]] && mkdir -p src/day${day}

echo "#lang racket" > src/day${day}/part1.rkt

./render_md.py $day

FILE="input/day${day}/input.txt"
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
wc -l ${FILE}
