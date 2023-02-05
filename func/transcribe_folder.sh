#!/bin/bash
# Based off of: https://www.baeldung.com/linux/bash-parse-command-line-arguments

# Black        0;30     Dark Gray     1;30
# Red          0;31     Light Red     1;31
# Green        0;32     Light Green   1;32
# Brown/Orange 0;33     Yellow        1;33
# Blue         0;34     Light Blue    1;34
# Purple       0;35     Light Purple  1;35
# Cyan         0;36     Light Cyan    1;36
# Light Gray   0;37     White         1;37
# printf "I ${RED}love${NC} Stack Overflow\n"
GREEN='\033[0;32m'
CYAN='\033[0;36m'
PURPLE='\033[0;35m'
RED='\033[0;31m'
NC='\033[0m' # No Color

print_usage() {
  echo "Usage: transcribe_folder.sh [-i --input directoryName/] [-e mkv] [-m --model modelName]"
  echo "  Model names: {tiny.en,tiny,base.en,base,small.en,small,medium.en,medium,large-v1,large-v2,large}"
  echo "  THIS WILL OVERRITE THE SOURCE FILE YOU PROVIDE WITH A NEW FILE !!!"
}

if [ $# -eq 0 ]; then
  print_usage
  exit 0
fi


VALID_ARGS=$(getopt -o i:e:m: --long input:,model: -- "$@")
if [[ $? -ne 0 ]]; then
  print_usage
  exit 1;
fi

eval set -- "$VALID_ARGS"
while [ : ]; do
  case "$1" in
    -i | --input)
        #echo "Processing 'input' option. Input argument is '$2'"
        INPUT_FOLDER="$2"
        shift 2
        ;;
    -e)
        #echo "Processing 'input' option. Input argument is '$2'"
        EXT="$2"
        shift 2
        ;;
    -m | --model)
        #echo "Processing 'model' option. Input argument is '$2'"
        MODEL_NAME="$2"
        shift 2
        ;;
    ?|:)
      echo "Invalid command option."
      print_usage
      exit 1
      ;;
    --) shift; 
        break 
        ;;
  esac
done

set -o errexit

#TOTAL=$(fdfind -I -e "$EXT" --full-path "$INPUT_FOLDER" | wc -l)

fdfind -I -e "$EXT" --full-path "$INPUT_FOLDER"

printf "${PURPLE}Transcribing directory with OpenAI Whisper ($MODEL_NAME model): $INPUT_FILE ${NC}\n"

#fdfind -I -e "$EXT" -j=1 -x transcribe.sh --input "{}" --model "$MODEL_NAME" -q \; --full-path "$INPUT_FOLDER" | tqdm --total "$TOTAL" --unit file --desc Processing
fdfind -I -e "$EXT" -j=1 -x transcribe.sh --input "{}" --model "$MODEL_NAME" \; --full-path "$INPUT_FOLDER"

printf "${PURPLE}Done!\n"
