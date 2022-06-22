#!/bin/sh

if [ "$#" -ne 1 ]
then
  echo "Usage: Must supply a domain"
  exit 1
fi

DOMAIN=$1

OUTPUT_PATH=./certs
mkdir $OUTPUT_PATH

openssl genrsa -out $OUTPUT_PATH/$DOMAIN.key 2048
openssl req -new -key $OUTPUT_PATH/$DOMAIN.key -out $OUTPUT_PATH/$DOMAIN.csr

cat > $OUTPUT_PATH/$DOMAIN.ext << EOF
authorityKeyIdentifier=keyid,issuer
basicConstraints=CA:FALSE
keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
subjectAltName = @alt_names
[alt_names]
DNS.1 = $DOMAIN
EOF

openssl x509 -req -in $OUTPUT_PATH/$DOMAIN.csr -CA CA/myCA.pem -CAkey CA/myCA.key -CAcreateserial \
-out $OUTPUT_PATH/$DOMAIN.crt -days 825 -sha256 -extfile certs/$DOMAIN.ext