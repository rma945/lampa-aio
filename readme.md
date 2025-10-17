## 🧩 Lampa AIO (All-in-One)

Lampa AIO is a lightweight Docker image that bundles the [Lampa](https://github.com/yumata/lampa) web application with an integrated auto-configuration system.
It allows you to easily preconfigure Lampa using a config.json file and optionally add custom plugins without any manual browser setup.

## 🚀 Features

- ✅ Runs Lampa in a single, minimal Alpine + Nginx container

- ⚙️ Automatically applies settings from config.json to browser localStorage

- 🔌 Supports pre-installed and custom JS plugins


## 🏗️ How It Works

When the container starts:

Nginx serves the Lampa web application under `/www/` and serve index.html with pre-injected script [auto-config.js](https://github.com/rma945/lampa-aio/blob/master/conf/auto-config.js), that automatically fetches [config.json](https://github.com/rma945/lampa-aio/blob/master/conf/config.json) configuration file.

All key/value pairs from the JSON file are saved into browser localStorage.

Lampa then starts with the preconfigured options (language, parser, torrent server, plugins, etc).

## ⚙️ Configuration

You can customize your Lampa setup using the config.json file:

```json
{
    "language": "en",
    "proxy_tmdb": false,
    "proxy_tmdb_auto": false,
    "parser_use": true,
    "parser_torrent_type": "jackett",
    "jackett_key": "",
    "jackett_url": "http://jacked.example.com",
    "player_torrent": "inner",
    "torrserver_url": "http://torrserver.example.com",
    "plugins": [
        {
            "url": "http://localhost:8080/plugins/iptv.js",
            "status": 1,
            "name": "IPTV",
            "author": "@lampa"
        },
        {
            "url": "http://localhost:8080/plugins/rating.js",
            "status": 1,
            "name": "Rating",
            "author": "@t_anton"
        },
        {
            "url": "http://localhost:8080/plugins/tracks.js",
            "status": 1,
            "name": "Tracks.js",
            "author": "@lampa"
        }
    ],
    "iptv_playlist_custom": [
        {
            "name": "iptv-example",
            "id": "iptv-example",
            "url": "http://iptv.example.com/api/tv/get.m3u",
            "custom": true
        }
    ]
}
```

In case if you need to add any new property for configuration file - just copy-paste it from your browser storage at lampa website


## 🧰 Usage

Run container and pass your config.json file and plugins folder into it.

```bash
docker run -d \
  --name lampa \
  -p 8080:8080 \
  -v $(pwd)/config.json:/www/config.json:ro \
  -v $(pwd)/plugins:/www/plugins:ro \
  ghcr.io/rma945/lampa-aio:latest
```
