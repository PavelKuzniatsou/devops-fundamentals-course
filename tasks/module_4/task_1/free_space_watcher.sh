#!/usr/bin/env bash

# default threshold value
threshold=60

if [ -z $1 ] 
then 
    echo Deafault threshold is used.
else
    threshold=$1
fi

echo Threshold: $threshold
echo "Press [CTRL+C] to stop..."
while true;
do
    used=$(df -Ph | grep '^/dev/.*' | awk 'NR==1 {print $5}' | cut -d'%' -f1)
    if [ $used -ge $threshold ]
    then
        partition=$(echo $data | awk '{print $2}')
        echo -e "\033[31mWARNING: $used% of total available space is used\033[0m"
        #break
    else
        echo -e "\033[32mState is good.Used: $used%\033[0m";
    fi
    sleep 5
done
echo Done
