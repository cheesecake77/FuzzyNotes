#!/bin/sh
# Change for whatever shell you like or leave as it is!

# There should be all my functions first.

function daily(){
  # Check if SN_DIRECTORY exists and create if not
  if [ ! -d $SN_DIRECTORY ]
  then
  mkdir "$SN_DIRECTORY"
  fi

  # If there is no daily note with today's date in specified format,
  # then we should create one
  if [ ! -f "$SN_DIRECTORY/$(date +"$SN_DATE_FORMAT").$SN_FILE_FORMAT" ]
  then
  touch "$SN_DIRECTORY/$(date +"$SN_DATE_FORMAT").$SN_FILE_FORMAT"
  fi

  # Now we sure that there is today's daily note, so we can
  # open it with specified editor
  $SN_EDITOR "$SN_DIRECTORY/$(date +$SN_DATE_FORMAT).$SN_FILE_FORMAT"
}

function open_or_create(){
  # Check if there's no file with such name - create it.
  # Then open with specified editor
  if [ ! -f "$1.$SN_FILE_FORMAT" ]
  then
    touch "$SN_DIRECTORY/$1.$SN_FILE_FORMAT"
  fi
  $SN_EDITOR "$SN_DIRECTORY/$1.$SN_FILE_FORMAT"
}
# If no arguements provided, we open today's daily note
if [ -z $1 ]
  then
    daily    
    exit
fi

# If there is one argument and it's not a command, we create or
# open a note with specified name
case $1 in
  *)
    note_name="$*"
    open_or_create "$note_name"
    ;;
esac
