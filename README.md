# talky

This repository shows how to deploy [a simple WebRTC application](https://github.com/simplewebrtc/simplewebrtc-talky-sample-app) on nginx-enabled Docker.


**Prerequisites**
* openssl
* Docker

**Setup**
1. Go to https://accounts.simplewebrtc.com to register an account then get your API key.
2. Open Dockerfile and update the SIMPLE_WEBRTC_API_KEY value.

**Instruction**
1. Generate an RSA public/private key pair to sign TLS/SSL certificates for deployment
```shell
openssl genrsa -des3 -out CA/myCA.key 2048
openssl req -x509 -new -nodes -key CA/myCA.key -sha256 -days 1825 -out CA/myCA.pem
```

2. Generate self-signed TLS/SSL certificates
```shell
bash gen_certs.sh
```

3. Build docker image
```shell
docker build -t talky .
```

4. Run it as daemon
```
docker run -it --rm -d -p 80:80 -p 443:443 --name talky talky:latest
```

5. Go to https://localhost or https://<local-IP> to use the application.
  
**Notes**
1. Check the firewall configuration if you cannot access the website
