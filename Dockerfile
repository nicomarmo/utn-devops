FROM node:16

WORKDIR /usr/src/app

# Copiar los archivos de la aplicación (asegúrate de tenerlos en el mismo directorio que el Dockerfile)
COPY package*.json ./
RUN git clone https://github.com/fedecurto98/web-app.git .
RUN if [ -f "package.json" ]; then npm install; fi

COPY . .

# Variables de conexión a la base de datos
ENV MYSQL_HOST=db
ENV MYSQL_USER=myuser
ENV MYSQL_PASSWORD=mypassword
ENV MYSQL_DATABASE=mydatabase

EXPOSE 8080

CMD ["node", "app.js"]