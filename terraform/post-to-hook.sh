#!/bin/sh

# get the url via `terraform output`
URL=`make output | grep base_url | awk -F '=' '{print $2}' | awk '{$1=$1};1'`
JSON="../test.json"
HMAC=`cat $JSON | openssl dgst -binary -sha256 -hmac "$TF_VAR_hmac_secret" | openssl base64`

echo "Calling the API endpoint. Make sure HMAC_SECRET is set in your environment."

echo "curl \"$URL\" --data-binary @${JSON} -H \"X-Castle-Signature: $HMAC\""

curl "$URL" --data-binary @${JSON} -H "X-Castle-Signature: $HMAC"
if [ $? -eq 0 ]; then
    echo "call succeeded 😀"
else
    echo "call failed 😱"
fi
