require 'rspotify'

module Chronicle
  module Spotify
    class SavedTracksExtractor < Chronicle::Spotify::SpotifyExtractor
      register_connector do |r|
        r.provider = 'spotify'
        r.description = 'saved tracks'
        r.identifier = 'saved-tracks'
      end

      def extract
        @proxy.saved_tracks(after: @config.since, limit: @config.limit) do |item|
          yield Chronicle::ETL::Extraction.new(data: item, meta: { user: @proxy.user })
        end
      end
    end
  end
end
