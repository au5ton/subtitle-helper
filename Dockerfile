FROM python:3.9-bullseye
RUN apt update && apt install -y ffmpeg mkvtoolnix fd-find nano git build-essential curl wget pv rsync && pip install ffsubsync openai-whisper tqdm
COPY silent.mp3 /root/.silent.mp3

# cache the openai models
# {tiny.en,tiny,base.en,base,small.en,small,medium.en,medium,large-v1,large-v2,large}
RUN whisper --model tiny.en --output_dir /tmp /tmp/doesnt_exist.mp3; exit 0
RUN whisper --model tiny --output_dir /tmp /tmp/doesnt_exist.mp3; exit 0
RUN whisper --model base.en --output_dir /tmp /tmp/doesnt_exist.mp3; exit 0
RUN whisper --model base --output_dir /tmp /tmp/doesnt_exist.mp3; exit 0
RUN whisper --model small.en --output_dir /tmp /tmp/doesnt_exist.mp3; exit 0
RUN whisper --model small --output_dir /tmp /tmp/doesnt_exist.mp3; exit 0
RUN whisper --model medium.en --output_dir /tmp /tmp/doesnt_exist.mp3; exit 0
RUN whisper --model medium --output_dir /tmp /tmp/doesnt_exist.mp3; exit 0
RUN whisper --model large-v1 --output_dir /tmp /tmp/doesnt_exist.mp3; exit 0
RUN whisper --model large-v2 --output_dir /tmp /tmp/doesnt_exist.mp3; exit 0
RUN whisper --model large --output_dir /tmp /tmp/doesnt_exist.mp3; exit 0

# just for cache busting these files
ARG CACHE_DATE=2016-01-01
RUN echo ${CACHE_DATE}

COPY func /root/.func
RUN chmod +x /root/.func/*.sh
ENV PATH="${PATH}:/root/.func"
# COPY bash_functions.sh /root/.bash_functions.sh
# COPY install-snippet.sh /root/.install-snippet.sh
# RUN cat /root/.install-snippet.sh >> /root/.bashrc
ENTRYPOINT [ "/bin/bash" ]