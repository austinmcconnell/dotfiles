# Locally-trusted Development Certificates

Use [mkcert](https://github.com/FiloSottile/mkcert)

First, create a new local Certificate Authority (CA) and add to system trust store

```shell
mkcert -install
```

Then, generate a local cert

```shell
mkcert -key-file local-key.pem -cert-file local-cert.pem localhost 127.0.0.1 dev.local *.dev.local
```

To generate a fullchain.pem file, run

```shell
# https://github.com/FiloSottile/mkcert/issues/214

# create chain file
cat local-cert.pem > chain.pem
cat "$(mkcert -CAROOT)/rootCA.pem" >> chain.pem
# create fullchain file
cat local-cert.pem > fullchain.pem
cat chain.pem >> fullchain.pem
```
