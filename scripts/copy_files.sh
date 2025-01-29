#!/bin/bash

# This script moves all files in a folder and its subfolders to a location of your choosing, based on a expression. 
# Usage: ./move_files.sh <search_folder> <destination_folder> <expression>
# The folder names may be absolute or relative.
# Example: ./move_files.sh /Users/Me/my_source_folder /Users/You/my_destination_folder "*.mp3"

# If less than three arguments supplied, display usage message
if [  $# -lt 3 ]; then 
  echo -e "\nUsage: ./move_files.sh <search_folder> <destination_folder> <expression> \n" 
  exit 1
fi 

# Sanitize any previous escaping from the arguments
SEARCH_FOLDER=$(echo "${1//\\}")
DESTINATION_FOLDER=$(echo "${2//\\}")
EXPRESSION=$3

# Create destination folder if it does not exist
mkdir -p $DESTINATION_FOLDER

echo "Searching folder $SEARCH_FOLDER and moving MP3s to $DESTINATION_FOLDER"
find "$SEARCH_FOLDER" -not -path '*/\.*' -name "$EXPRESSION" -print0 | while read -d $'\0' FILE
do
  echo "Copying $FILE"
  if ! cp "$FILE" "$DESTINATION_FOLDER"; then
    echo -e "\n Copy failed!"
    exit 1
  fi
done

echo -e "\nMove completed!\n"
