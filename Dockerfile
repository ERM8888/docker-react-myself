# Se puede utilizar un alias para este build stage
FROM node:alpine as builder
WORKDIR '/app'
COPY package.json .
RUN npm install
# En el copy no se necesita volumes ya que este dockerfile es para produccion
COPY . .
# build folder sera creado en el working directory: /app/build sera el directorio
RUN npm run build
# Empieza la segunda fase: Run phase. Docker supone que poniendo FROM se cierra la anterior fase
FROM nginx
# Se expone el puerto 80 para que sea utilizado en AWS Beanstalk
# Para el localhost no hace nada, pero para Beanstalk le dice que tiene que mapear este puerto y lo hace de forma automática
EXPOSE 80
# Se quiere copiar desde algo que acabamos de trabajar. El folder de este container donde se copiara depende de la imagen de nginx
COPY --from=builder /app/build /usr/share/nginx/html
# No se necesita CMD ya que automaticamente empezará el server