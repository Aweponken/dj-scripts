#!/bin/bash

# This script renames MP3 files to a name that matches a pattern. 
# The pattern elements can be found here: https://eyed3.readthedocs.io/en/latest/plugins/display_plugin.html#pattern-elements
# Usage: ./rename_files_from_id3_tag.sh /Users/Me/Music/ "%title%_%artist%"
# Note: This script requires eyeD3 and grako, which can be install with: pip3 install eyeD3 grako
# Note2: eyeD3 requires python >= 3.6

# If less than two arguments supplied, display usage message
if [  $# -lt 2 ]; then 
  echo -e "\nUsage: ./remove_files.sh <search_folder> <pattern> \n" 
  exit 1
fi

# Verify that eyed3 and grako is installed
if ! command -v eyed3 &> /dev/null; then
    echo "eyed3 could not be found. Please install it with: pip3 install eyed3"
    exit 1
elif ! command -v grako &> /dev/null; then
    echo "grako could not be found. Please install it with: pip3 install grako"
    exit 1
fi

SEARCH_FOLDER=$(echo "${1//\\}")
PATTERN=$2
EXPRESSION="*.mp3"

echo "Searching folder $SEARCH_FOLDER"
find "$SEARCH_FOLDER" -name "$EXPRESSION" -print0 | while read -d $'\0' FILE
do
  echo "Renaming $FILE"
  DIR_OF_FILE=$(dirname "${FILE}")
  RAW_NEW_FILE_NAME=$(eyed3 --plugin display --pattern "$PATTERN" "$FILE")
  NEW_FILE_NAME=$(echo "${RAW_NEW_FILE_NAME//\/}") # Remove any slashes in the new file name
  if ! mv "$FILE" "$DIR_OF_FILE/$NEW_FILE_NAME.mp3"; then
    echo -e "\nRename failed!\n"
    exit 1
  fi
done

echo -e "\nRename completed!\n"