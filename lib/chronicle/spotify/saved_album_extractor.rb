module Chronicle
  module Spotify
    class SavedAlbumExtractor < Chronicle::Spotify::SpotifyExtractor
      register_connector do |r|
        r.source = :spotify
        r.type = :saved_album
        r.strategy = :api
        r.description = 'saved_albums'
      end

      def extract
        @proxy.saved_albums(after: @config.since, limit: @config.limit) do |item|
          yield build_extraction(data: item, meta: { agent: @agent })
        end
      end
    end
  end
end
