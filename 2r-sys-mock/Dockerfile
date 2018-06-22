FROM node

EXPOSE 20000

RUN npm install -g json-server

WORKDIR /server

CMD ["json-server", "data.json", "--port", "5000", "--static", "./public"]
