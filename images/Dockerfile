FROM ubuntu:latest

RUN apt-get update && apt-get install -y python3 python3-pip && apt-get clean
RUN pip install Flask

COPY ../helloWorld.py /home/helloWorld.py
EXPOSE 5000

CMD [ "python3", "/home/helloWorld.py" ]
