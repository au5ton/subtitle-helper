# subtitle-helper

## Help (PowerShell)

Build:

```powershell
docker build --build-arg CACHE_DATE="$(date)" -t 'subhelper:latest' .; docker image prune -f
```

Run:

```powershell
docker run -it --rm -v ${PWD}:/data subhelper
```

Find (doesn't work):

```bash
fdfind -I -e mkv -j 1 -x print_something {}
fdfind -I -e mkv -j 1 -x bash -c "source /root/.bashrc && print_something {}"
```

## TODO

- [ ] If a file already has subtitles (either embedded or adjacent to the MKV file):
  - [ ] Extract all the subtitles from the MKV file
  - [ ] Run `ffsubsync` on the MKV file and extracted subtitle file
  - [ ] Run `mkvmerge` on the MKV and the newly created re-synced subtitle file. Give the synced subtitle a custom title so it is distinguishable from a video player (ex: `{{ OLD TITLE }} (ffsubsync)`).
- [ ] If a file doesn't have subtitles:
  - [ ] Using a VAD (Voice Activity Detector), silence the parts of the MKV file that aren't a voice
    - This is intended to improve the accuracy of Whisper, but may not have an effect at all
  - [ ] Using OpenAI's Whisper, transcribe the MKV file to a newly created subtitle file
  - [ ] Run `mkvmerge` on the MKV and the newly created subtitle file. Give the subtitle a custom title so it is distinguishable from a video player (ex: `English (OpenAI Whisper)`).