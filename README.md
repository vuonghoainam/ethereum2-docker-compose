


### User id 2000
Some components like grafana and nimbus need folders with special permission and/or owner. To make the setup of ethereum2-docker-compose as simple as possible these necessary permissions will be set on each startup with the user id of 2000.

It's possible (however highly unlikely) that your local system already has a user with the id of 2000. In this case the folders will show the name of your user. We recommend not using a local user with the id 2000 for security reasons.

```
ethdo wallet create --type=hd --mnemonic="series drum switch attack pilot siege mirror mask drive code raven abandon direct glue dress only soft secret hurry occur depth evoke item silk" --wallet="lydiatest" --wallet-passphrase="hoainam96"

ethdo account create --account="lydiatest/setup" --wallet-passphrase="hoainam96" --passphrase="hoainam96"

cp -r ~/.config/ethereum2/wallets/* wallets/.
openssl rand -hex 32 | tr -d "\n" > config/jwt.hex

sudo timedatectl set-ntp on
```

