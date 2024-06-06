#!/bin/zsh
function daily(){
  # Check if SN_DIR and SN_DAILY_DIR exists and create if not
  if [ ! -d $SN_DIR ]
  then
  mkdir -p "$SN_DIR"
  fi

  if [ ! -d $SN_DAILY_DIR ]
  then
  mkdir -p "$SN_DAILY_DIR"
  fi

  # If there is no daily note with today's date in specified format,
  # then we should create one
  if [ ! -f "$SN_DAILY_DIR/$(date +"$SN_DATE_FORMAT").$SN_FILE_FORMAT" ]
  then
  touch "$SN_DAILY_DIR/$(date +"$SN_DATE_FORMAT").$SN_FILE_FORMAT"
  fi

  # Now we sure that there is today's daily note, so we can
  # open it with specified editor
  $SN_EDITOR "$SN_DIR/$(date +$SN_DATE_FORMAT).$SN_FILE_FORMAT"
}

function open_or_create(){
  # Check if there's no file with such name - create it.
  # Then open with specified editor
  if [ ! -f "$1.$SN_FILE_FORMAT" ]
  then
    touch "$SN_DIR/$1.$SN_FILE_FORMAT"
  fi
  $SN_EDITOR "$SN_DIR/$1.$SN_FILE_FORMAT"
}

function search(){
  f=$(find "$SN_DIR"\
    -type f\
    -name "*.$SN_FILE_FORMAT"\
    -exec basename {} .$SN_FILE_FORMAT \;)
 fnd=$(echo $f | fzf -i)
 echo $fnd
}

function append(){
  echo i should append this
  echo "$1"
  echo to daily note
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
  s)
    search "$2"
    ;;
  a)
    shift
    append "$@"
    ;;
  *)
    open_or_create "$*"
    ;;
esac
