


### User id 2000
Some components like grafana and nimbus need folders with special permission and/or owner. To make the setup of ethereum2-docker-compose as simple as possible these necessary permissions will be set on each startup with the user id of 2000.

It's possible (however highly unlikely) that your local system already has a user with the id of 2000. In this case the folders will show the name of your user. We recommend not using a local user with the id 2000 for security reasons.

```
ethdo wallet create --type=hd --mnemonic="series drum switch attack pilot siege mirror mask drive code raven abandon direct glue dress only soft secret hurry occur depth evoke item silk" --wallet="lydiatest" --wallet-passphrase="hoainam96"

ethdo account create --account="lydiatest/setup" --wallet-passphrase="hoainam96" --passphrase="hoainam96"

cp -r ~/.config/ethereum2/wallets/* wallets/.
openssl rand -hex 32 | tr -d "\n" > config/jwt.hex

sudo timedatectl set-ntp on

./deposit new-mnemonic --num_validators=3 --mnemonic_language=english --chain=prater

Thì ra 3 cái key và 1 cái deposit data rồi
deposit_data-1684486837.json  keystore-m_12381_3600_0_0_0-1684486835.json  keystore-m_12381_3600_1_0_0-1684486836.json  keystore-m_12381_3600_2_0_0-1684486837.json
```

