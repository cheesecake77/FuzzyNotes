#!/bin/zsh

function init(){
  if [ ! -d $SN_DIR ]
  then
  mkdir -p "$SN_DIR"
  fi

  if [ ! -d $SN_DAILY_DIR ]
  then
  mkdir -p "$SN_DAILY_DIR"
  fi

  if [ ! -f "$SN_DAILY_DIR/$(date +$SN_DATE_FORMAT).$SN_FILE_FORMAT" ]
  then
    touch "$SN_DIR/$(date +$SN_DATE_FORMAT).$SN_FILE_FORMAT"
  fi
}

function daily(){
  $SN_EDITOR "$SN_DAILY_DIR/$(date +$SN_DATE_FORMAT).$SN_FILE_FORMAT"
}

function open_or_create(){
  if [ ! -f "$SN_DIR.$1.$SN_FILE_FORMAT" ]
  then
    touch "$SN_DIR/$1.$SN_FILE_FORMAT"
  fi
  $SN_EDITOR "$SN_DIR/$1.$SN_FILE_FORMAT"
}

function search(){
  f=$(find "$SN_DIR"\
    -maxdepth 1\
    -type f\
    -name "*.$SN_FILE_FORMAT"\
    -exec basename {} .$SN_FILE_FORMAT \;)
 fnd=$(echo $f | fzf -i)

 if [[ -n "$fnd" ]]
 then
 open_or_create "$fnd"
 fi
}

function append(){
  echo "$1" >> "$SN_DAILY_DIR/$(date +$SN_DATE_FORMAT).$SN_FILE_FORMAT"
}

#MAIN
source /home/$(whoami)/.config/FuzzyNotes/fn.config

init

if [ -z $1 ]
  then
    daily    
    exit
fi

case $1 in
  s)
    search "$2"
    ;;
  a)
    shift
    append "$*"
    ;;
  *)
    open_or_create "$*"
    ;;
esac
