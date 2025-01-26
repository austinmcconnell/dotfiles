# Locally-trusted Development Certificates

## mkcert

Install [mkcert](https://github.com/FiloSottile/mkcert) with

```shell
brew install mkcert
```

Create a new local Certificate Authority (CA) and add to system trust store

```shell
mkcert -install
```

Cenerate a local cert

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

### Export CA to other systems

Adding the CA to the trust store does not require the CA key, so you can export the CA Certificates
and use `mkcert` to install it on other machines.

Remember that `mkcert` is meant for development purposes, not production, so it should not be used
on end users machines. Also remember that **you should not export or share `rootCA-key.pem`**.

Find the `rootCA.pem` file in `mkcert -CAROOT`

```shell
cd $(mkcert -CAROOT)
```

and then

```shell
ls
rootCA-key.pem  rootCA.pem
```

and copy it to a different machine.

Set `$CAROOT` to its directory

```shell
export CAROOT=.
```

and run

```shell
mkcert -install
```
