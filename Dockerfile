FROM node:14-stretch AS builder

ENV SIMPLE_WEBRTC_API_KEY 4d216e5543a6281e30100182

RUN apt-get update \
    && apt-get install curl \
    && cd /tmp \
    && curl https://codeload.github.com/simplewebrtc/simplewebrtc-talky-sample-app/zip/refs/heads/master --output talky.zip \
    && unzip talky.zip 

# Set working dir
WORKDIR /talky

RUN cp -rf /tmp/simplewebrtc-talky-sample-app-master/* ./ \
    && API_KEY=${SIMPLE_WEBRTC_API_KEY} \
    && sed -i "s/\/config\/guest\/YOUR_API_KEY/\/config\/guest\/$API_KEY/g" public/index.html \
    && npm install \
    && npm audit fix \
    && npm run build

### Deployment

FROM nginx:stable-alpine

COPY ./CA/myCA.pem /usr/local/share/ca-certificates/my-cert.crt

RUN cat /usr/local/share/ca-certificates/my-cert.crt >> /etc/ssl/certs/ca-certificates.crt

# Set working dir
WORKDIR /talky
RUN mkdir -p certs/

COPY ./certs/* ./certs/
COPY ./nginx-conf /etc/nginx/conf.d/default.conf
COPY --from=builder /talky/dist/* /usr/share/nginx/html/
