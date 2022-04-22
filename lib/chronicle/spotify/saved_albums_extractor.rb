module Chronicle
  module Spotify
    class SavedAlbumsExtractor < Chronicle::Spotify::SpotifyExtractor
      register_connector do |r|
        r.provider = 'spotify'
        r.description = 'saved albums'
        r.identifier = 'saved-albums'
      end

      def extract
        @proxy.saved_albums(after: @config.since, limit: @config.limit) do |item|
          yield Chronicle::ETL::Extraction.new(data: item, meta: { user: @proxy.user })
        end
      end
    end
  end
end
