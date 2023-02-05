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