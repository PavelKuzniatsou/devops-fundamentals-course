#!/usr/bin/env bash

declare fileName=users.db
declare fileDir=../data
declare filePath=$fileDir/$fileName

if [[ "$1" != "help" && "$1" != "" && ! -f ../data/users.db ]];
then
    read -r -p "users.db does not exist. Do you want to create it? [Y/n] " answer
    answer=${answer,,}
    if [[ "$answer" =~ ^(yes|y)$ ]];
    then
        touch $fileName
        echo "File ${fileName} is created."
    else
        echo "File ${fileName} must be created to continue. Try again." >&2
        exit 1
    fi
fi

function validateInput {
  local input=$1

  if [[ ! "$input" =~ ^[a-zA-Z\ ]+$ ]]; then
    echo "Input must be latin letters!"
    exit 1
  fi
}

function add {
    read -p "Enter user name: " username
    validateInput $username
    read -p "Enter user role: " role
    validateInput $role

    echo "${username}, ${role}" >> $filePath
}

function backup {
  backupFileName=$(date +'%Y-%m-%d-%H-%M-%S')-users.db.backup
  cp $filePath $fileDir/$backupFileName

  echo "Backup is created."
}

function restore {
  latestBackupFile=$(ls $fileDir/*-$fileName.backup | tail -n 1)

  if [[ ! -f $latestBackupFile ]]
  then
    echo "No backup file found."
    exit 1
  fi

  cat $latestBackupFile > $filePath

  echo "Backup is restored."
}

function find {
    read -p "Enter username to search: " username

    output=$(cat $filePath | grep ^$username[,])

    if [[ -z $output ]]
    then
        echo "User not found."
        exit 1
    else
        cat $filePath | grep ^$username[,]
    fi
}

inverseParam="$2"
function list {
    if [[ $inverseParam == "--inverse" ]]
    then
      cat --number $filePath | tac
    else
      cat --number $filePath
    fi
}

function help {
    echo "Manages users in db. It accepts a single parameter with a command name."
    echo
    echo "Syntax: db.sh [command]"
    echo
    echo "List of available commands:"
    echo
    echo "add       Adds a new line to the users.db. Script must prompt user to type a
                    username of new entity. After entering username, user must be prompted to
                    type a role."
    echo "backup    Creates a new file, named" $filePath".backup which is a copy of
                    current" $fileName
    echo "find      Prompts user to type a username, then prints username and role if such
                    exists in users.db. If there is no user with selected username, script must print:
                    “User not found”. If there is more than one user with such username, print all
                    found entries."
    echo "list      Prints contents of users.db in format: N. username, role
                    where N – a line number of an actual record
                    Accepts an additional optional parameter inverse which allows to get
                    result in an opposite order – from bottom to top"
}


export $1
case $1 in
  add)            add ;;
  backup)         backup ;;
  restore)        restore ;;
  find)           find ;;
  list)           list ;;
  help | '' | *)  help ;;
esac
