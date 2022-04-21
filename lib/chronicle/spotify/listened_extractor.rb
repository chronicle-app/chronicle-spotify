require 'rspotify'

module Chronicle
  module Spotify
    class ListenedExtractor < Chronicle::Spotify::SpotifyExtractor
      register_connector do |r|
        r.provider = 'spotify'
        r.description = 'listened tracks'
        r.identifier = 'listened'
      end

      def extract
        @proxy.recently_played(after: @config.since, limit: @config.limit, before: @config.until) do |item|
          yield Chronicle::ETL::Extraction.new(data: item, meta: { user: @proxy.user })
        end
      end
    end
  end
end
