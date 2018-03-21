FROM alpine:3.6

# Set timezone
RUN apk add --update tzdata
RUN cp -r -f /usr/share/zoneinfo/America/Los_Angeles /etc/localtime
RUN echo "America/Los_Angeles" > /etc/timezone

# Install other things we need
RUN apk add --update curl ffmpeg jq nodejs nodejs-npm
RUN npm install express serve-static forever -g
ENV NODE_PATH /usr/lib/node_modules/

# Copy the scripts and run it
COPY ripper-bin/ /ripper-bin
COPY conf.sh /
CMD "/ripper-bin/main.sh"
EXPOSE 8888
