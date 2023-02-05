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