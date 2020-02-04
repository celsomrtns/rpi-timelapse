#!/bin/bash

#Iniciando Timelapse (4h)
raspistill -t 28800000 -tl 15000 -q 90 -ex verylong -w 1920 -h 1080 -o image%04d.jpg

#Convertendo em ordem todos os arquivos
num=0
for file in *.jpg; do
        mv "$file" "imagem$(printf "%04d" $num).jpg"
        let num=$num+1
done


#convertendo o MP4
avconv -r 10 -i imagem%04d.jpg -r 10 -vcodec libx264 -vf scale=1920:1080 timelapse.mp4

#Enviando para o YouTube
DATE=$(date +"%Y-%m-%d_%H%M%S")
sudo python upload_video.py --file="timelapse.mp4" --title="Timelapse Curitiba - $DATE" --description="Timelapse gerado automaticamente via Raspberry Pi a cada 8h" --keywords="timelapse,curitiba,raspberry" --category="22" --privacyStatus="public"

#Apagando lixo
sudo rm *.jpg
sudo rm *.mp4

#fim/loop
sudo ./timelapse.sh
