# Chronicle::Spotify
[![Gem Version](https://badge.fury.io/rb/chronicle-spotify.svg)](https://badge.fury.io/rb/chronicle-spotify)

Extract your Spotify history using the command line with this plugin for [chronicle-etl](https://github.com/chronicle-app/chronicle-etl).

## Usage

### 1. Install Chronicle-ETL and this plugin

```sh
# Install chronicle-etl and this plugin
$ gem install chronicle-etl
$ chronicle-etl plugins:install spotify
```

### 2. Create a Spotify App
To get access to the Spotify API, you must first create an app. Press the "Create an app" button in the [Developer Dashboard](https://developer.spotify.com/dashboard/applications).

After your app has been created, grab the client_id and client_secret credentials and save them to chronicle-etl secrets:

```sh
$ chronicle-etl secrets:set spotify client_id
$ chronicle-etl secrets:set spotify client_secret
```

### 3. Authorize Spotify

Next, we need an access token for accessing your data. We can use the authorization flow:

```sh
$ chronicle-etl authorizations:new spotify
```

This will open a browser window to authorize on spotify.com. When the flow is complete, access/refresh tokens will be saved in the chronicle secret system under the "spotify" namespace. It'll be available automatically whenever you use this plugin.

### 4. Use the the plugin
```sh
# Extract recent limits
$ chronicle-etl --extractor spotify:listens --limit 10

# Extract liked tracks from the last week
$ chronicle-etl --extractor spotify:liked-tracks --since 1w
# Transform as Chronicle Schema
$ chronicle-etl --extractor spotify:liked-tracks --since 1w --transformer chronicle:like --loader json

# Extract saved albums
$ chronicle-etl --extractor spotify:saved-albums --limit 10
```

## Available Connectors
### Extractors

All the extractors expect `uid`, `access_token` and `refresh_token` to be available in your Chronicle secrets. After doing the authorization flow, you can verify that they exist using: `$ chronicle-etl secrets:list spotify`

#### `liked-tracks`

Extractor for your Spotify liked tracks

#### `saved-albums`

Extractor for your Spotify saved albums
#### `listens`

Extractor for your recent listens. Due to API limitations, only your 50 most recent 

### Transformers

#### `like`

Transform a like (either from `saved-albums` or `liked-tracks`) into Chronicle Schema

#### `listen`

Transforms a listen (from `listens`) into Chronicle Schema

## Roadmap
- extractor for playlist activity ([#3](https://github.com/chronicle-app/chronicle-spotify/issues/3))
- incorporate more Spotify metadata into the transformed records
