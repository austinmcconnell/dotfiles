# SSH (Mac OS)

Information about SSH on Mac OS

## Config

The `ControlMaster`, `ControlPath`, and `ControlPersist` keywords allow sessions to share a single
network connection.

```bash
Host *
   AddKeysToAgent yes
   UseKeychain yes
   IdentityFile ~/.ssh/name of key
   ControlMaster  auto
   ControlPath  ~/.ssh/controlmasters/%r@%h:%p
   ControlPersist 4h
```

> Since the first obtained value for each parameter is used, more host-specific declarations should
> be given near the beginning of the file, and general defaults at the end.

[https://man.openbsd.org/ssh_config#DESCRIPTION](https://man.openbsd.org/ssh_config#DESCRIPTION)

## Managing Keys

Add a key

```bash
ssh-add --apple-use-keychain ~/.ssh/name of key
```

Delete a key

```bash
ssh-add -d <keyfile>
```

List active keys

```bash
ssh-add -l
```

## Keys

Fix permissions

```bash
sudo chmod 755 ~/.ssh
sudo chmod 600 /path/to/my/key.pem
```
