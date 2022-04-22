# frozen_string_literal: true

require 'chronicle/etl'

require_relative "spotify/version"

require_relative "spotify/authorizer"
require_relative "spotify/proxy"
require_relative "spotify/builders"

require_relative "spotify/spotify_extractor"
require_relative "spotify/listens_extractor"
require_relative "spotify/liked_tracks_extractor"
require_relative "spotify/saved_albums_extractor"

require_relative "spotify/like_transformer"
require_relative "spotify/listen_transformer"
module Chronicle
  module Spotify
  end
end
