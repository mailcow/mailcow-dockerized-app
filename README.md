# ⚠️ATTENTION⚠️ 
This repo is using for development purposes of CowUI. So do not use it instead of original mailcow-dockerized!


# mailcow: dockerized - 🐮 + 🐋 = 💕

## How can you run it?

- First you need to init submodules:
```
# Get the repo
git clone https://github.com/mailcow/mailcow-dockerized-app.git && cd mailcow-dockerized-app/

# Init submodules
git submodule init

# Get the latest commits
git submodule update --remote --recursive
```

- After that you need the create mailcow config and build CowUI services:
```
# Generate the config
./generate_config.sh

# Build necessary services images locally
docker-compose build cowui-backend-mailcow cowui-frontend-mailcow sync-engine-mailcow
```

- Last, pull remaining images and up the compose:
```
docker-compose pull 
docker-compose up -d
```

## Want to support mailcow?

Please [consider a support contract with Servercow](https://www.servercow.de/mailcow?lang=en#support) to support further development. _We_ support _you_ while _you_ support _us_. :)

You can also [get a SAL](https://www.servercow.de/mailcow?lang=en#sal) which is a one-time payment with no liabilities or returning fees.

Or just spread the word: moo.

## Info, documentation and support

Please see [the official documentation](https://mailcow.github.io/mailcow-dockerized-docs/) for installation and support instructions. 🐄

🐛 **If you found a critical security issue, please mail us to [info at servercow.de](mailto:info@servercow.de).**

## Cowmunity

[mailcow community](https://community.mailcow.email)

[Telegram mailcow channel](https://telegram.me/mailcow)

[Telegram mailcow Off-Topic channel](https://t.me/mailcowOfftopic)

Telegram desktop clients are available for [multiple platforms](https://desktop.telegram.org). You can search the groups history for keywords.

## Misc

**Important**: mailcow makes use of various open-source software. Please assure you agree with their license before using mailcow.
Any part of mailcow itself is released under **GNU General Public License, Version 3**.
