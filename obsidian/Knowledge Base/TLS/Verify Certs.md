# Verify Certs

Simple way to verify a TLS certificate chain

```shell
openssl s_client -connect yourdomain.com:443 -showcerts
```

More detailed way to verify a TLS certificate chain

```bash
#!/bin/bash

set -euo pipefail

error() {
    echo "Error: $1" >&2
    exit 1
}

# Check if hostname parameter is provided
if [ $# -ne 1 ]; then
    error "Usage: $0 <hostname>"
fi

HOSTNAME="$1"

echo -e '\nTesting connection...'
nc -zv "$HOSTNAME" 443 || error "Cannot connect to server"

echo -e '\nRemoving any existing certificates...'
rm -f chain.pem cert*.pem

echo -e '\nFetching certificate chain...'
openssl s_client -showcerts -connect "${HOSTNAME}:443" </dev/null >chain.pem || true

echo -e '\nExtracting certificates...'
awk 'BEGIN {n=0} /-----BEGIN CERTIFICATE-----/,/-----END CERTIFICATE-----/ {print > ("cert" n ".pem")} /-----END CERTIFICATE-----/ {n++}' <chain.pem

echo -e '\nVerifying certificates...'
for cert in cert*.pem; do
    echo -e "\n=== $cert ==="
    openssl x509 -in "$cert" -noout -subject -issuer -dates
done

echo -e '\nVerifying complete chain...'
openssl verify -verbose -untrusted chain.pem chain.pem
```

A link to the above script can be found [here](https://github.com/austinmcconnell/dotfiles/blob/main/scripts/verify-certs.sh)
