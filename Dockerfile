FROM node:6.11.2
WORKDIR /work

RUN npm install -g coffee-script 

COPY package.json .
RUN npm install

COPY hubot.sh .

COPY external-scripts.json .
COPY scripts scripts/

ENTRYPOINT ["sh", "hubot.sh"]
