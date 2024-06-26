module Chronicle
  module Spotify
    class SavedTracksExtractor < Chronicle::Spotify::SpotifyExtractor
      register_connector do |r|
        r.source = :spotify
        r.type = :like
        r.strategy = :api
        r.description = 'liked tracks'
      end

      def extract
        @proxy.saved_tracks(after: @config.since, limit: @config.limit) do |item|
          yield build_extraction(data: item, meta: { agent: @agent })
        end
      end
    end
  end
end
