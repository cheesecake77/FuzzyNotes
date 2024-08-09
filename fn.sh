#!/bin/zsh

function init(){
  if [ ! -d $FN_DIR ]
  then
  mkdir -p "$FN_DIR"
  fi

  if [ ! -d $FN_DAILY_DIR ]
  then
  mkdir -p "$FN_DAILY_DIR"
  fi

  if [ ! -f "$FN_DAILY_DIR/$(date +$FN_DATE_FORMAT).$FN_FILE_FORMAT" ]
  then
    touch "$FN_DIR/$(date +$FN_DATE_FORMAT).$FN_FILE_FORMAT"
  fi
}

function daily(){
  $FN_EDITOR "$FN_DAILY_DIR/$(date +$FN_DATE_FORMAT).$FN_FILE_FORMAT"
}

function open_or_create(){
  if [ ! -f "$FN_DIR.$1.$FN_FILE_FORMAT" ]
  then
    touch "$FN_DIR/$1.$FN_FILE_FORMAT"
  fi
  $FN_EDITOR "$FN_DIR/$1.$FN_FILE_FORMAT"
}

function search(){
  f=$(find "$FN_DIR"\
    -maxdepth 1\
    -type f\
    -name "*.$FN_FILE_FORMAT"\
    -exec basename {} .$FN_FILE_FORMAT \;)
 fnd=$(echo $f | fzf -i)

 if [[ -n "$fnd" ]]
 then
 open_or_create "$fnd"
 fi
}

function append(){
  echo "$1" >> "$FN_DAILY_DIR/$(date +$FN_DATE_FORMAT).$FN_FILE_FORMAT"
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
