#!/bin/bash
# Based off of: https://www.baeldung.com/linux/bash-parse-command-line-arguments

# need
# - location of file
# - model name

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
RED='\033[0;31m'
NC='\033[0m' # No Color

print_usage() {
  echo "Usage: transcribe.sh [-i --input fileName.mkv] [-m --model modelName]"
  echo "  Model names: {tiny.en,tiny,base.en,base,small.en,small,medium.en,medium,large-v1,large-v2,large}"
  echo "  THIS WILL OVERRITE THE SOURCE FILE YOU PROVIDE WITH A NEW FILE !!!"
}

if [ $# -eq 0 ]; then
  print_usage
  exit 0
fi


VALID_ARGS=$(getopt -o i:m: --long input:,model: -- "$@")
if [[ $? -ne 0 ]]; then
  print_usage
  exit 1;
fi

eval set -- "$VALID_ARGS"
while [ : ]; do
  case "$1" in
    -i | --input)
        #echo "Processing 'input' option. Input argument is '$2'"
        INPUT_FILE="$2"
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

INPUT_FILE_BASENAME=$(basename "$INPUT_FILE")
INPUT_FILE_DIRNAME=$(dirname "$INPUT_FILE")
TMP_FILE="/tmp/$INPUT_FILE_BASENAME"
SUBTITLE_FILE="$TMP_FILE.vtt"


# actually do the transcribing, produces a file at "$TMP_FILE.vtt"
printf "${CYAN}Transcribing with OpenAI Whisper ($MODEL_NAME model): $INPUT_FILE ${NC}\n"
time whisper --model tiny --language en --output_format vtt --output_dir /tmp "$INPUT_FILE"
# merge the subtitle and source file into a new file
printf "${CYAN}Merging VTT subtitle with source MKV file${NC}\n"
mkvmerge -o "$TMP_FILE" "$INPUT_FILE" --language 0:eng --track-name "0:English (OpenAI Whisper, $MODEL_NAME model)" "$SUBTITLE_FILE"
# overrite the source file with the new file
if [[ $INPUT_FILE == *.mkv ]]; then
  printf "${CYAN}Overriting source file with merged MKV${NC}\n"
  FILE_DESTINATION="$INPUT_FILE"
else
  printf "${CYAN}Copying merged MKV to source directory${NC}\n"
  FILE_DESTINATION="$INPUT_FILE.mkv"
fi
rsync -ah --progress "$TMP_FILE" "$FILE_DESTINATION"
# delete the temp file
rm "$TMP_FILE"
rm "$SUBTITLE_FILE"

printf "${GREEN}Done!\nOutput file is: $FILE_DESTINATION${NC}\n"

# echo "INPUT: $INPUT_FILE"
# echo "MODEL: $MODEL_NAME"