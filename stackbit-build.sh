#!/usr/bin/env bash

set -e
set -o pipefail
set -v

curl -s -X POST https://api.stackbit.com/project/5e791d803e29fb00142a2c4e/webhook/build/pull > /dev/null
if [[ -z "${STACKBIT_API_KEY}" ]]; then
    echo "WARNING: No STACKBIT_API_KEY environment variable set, skipping stackbit-pull"
else
    npx @stackbit/stackbit-pull --stackbit-pull-api-url=https://api.stackbit.com/pull/5e791d803e29fb00142a2c4e 
fi
curl -s -X POST https://api.stackbit.com/project/5e791d803e29fb00142a2c4e/webhook/build/ssgbuild > /dev/null
jekyll build
./inject-netlify-identity-widget.js _site
curl -s -X POST https://api.stackbit.com/project/5e791d803e29fb00142a2c4e/webhook/build/publish > /dev/null
