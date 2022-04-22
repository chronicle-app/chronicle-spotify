module Chronicle
  module Spotify
    class SavedTracksExtractor < Chronicle::Spotify::SpotifyExtractor
      register_connector do |r|
        r.provider = 'spotify'
        r.description = 'liked tracks'
        r.identifier = 'liked-tracks'
      end

      def extract
        @proxy.saved_tracks(after: @config.since, limit: @config.limit) do |item|
          yield Chronicle::ETL::Extraction.new(data: item, meta: { actor: @actor })
        end
      end
    end
  end
end
