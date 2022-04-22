# Chronicle::Spotify
[![Gem Version](https://badge.fury.io/rb/chronicle-spotify.svg)](https://badge.fury.io/rb/chronicle-spotify)

Extract your Spotify history using the command line with this plugin for [chronicle-etl](https://github.com/chronicle-app/chronicle-etl).

## Usage

```sh
# Install chronicle-etl and this plugin
$ gem install chronicle-etl
$ chronicle-etl plugins:install spotify
```

### 1. Create a Spotify App
To get access to the Spotify API, you must first create an app. Press the "Create an app" button in the [Developer Dashboard](https://developer.spotify.com/dashboard/applications).

Then save the credentials: 
```sh
$ chronicle-etl secrets:set spotify client_id CLIENT_ID
$ chronicle-etl secrets:set spotify client_secret
```

### 2. Authorize Spotify

To get an access token that's required by this plugin, use the authorization flow:

```sh
$ chronicle-etl authorizations:new spotify
```

This will save an access and refresh token in the chronicle secret system under the "spotify" namespace.

### 3. Use the Chronicle plugin
```sh
$ chronicle-etl --extractor spotify:listens --limit 10
$ chronicle-etl --extractor spotify:saved-albums --limit 10
$ chronicle-etl --extractor spotify:liked-tracks --limit 10
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