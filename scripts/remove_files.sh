#!/bin/bash

# This script removes files that matches an expression, such as *.mp3
# Usage: ./remove_files.sh <search_folder> <expression>
# The folder name may be absolute or relative.

# If less than two arguments supplied, display usage message
if [  $# -lt 2 ]; then 
  echo -e "\nUsage: ./remove_files.sh <search_folder> <expression> \n" 
  exit 1
fi 


# Sanitize any previous escaping from the folder argument
SEARCH_FOLDER=$(echo "${1//\\}")
EXPRESSION=$2


echo "Searching folder $SEARCH_FOLDER for files matching $EXPRESSION"
find "$SEARCH_FOLDER" -name "$EXPRESSION" -print0 | while read -d $'\0' FILE
do
  echo "Removing $FILE"
  if ! rm "$FILE"; then
    echo -e "\nRemoval failed!\n"
    exit 1
  fi
done

echo -e "\nRemoval completed!\n"