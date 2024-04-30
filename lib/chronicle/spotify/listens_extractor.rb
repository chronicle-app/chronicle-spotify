module Chronicle
  module Spotify
    class ListenedExtractor < Chronicle::Spotify::SpotifyExtractor
      register_connector do |r|
        r.source = :spotify
        r.type = :listen
        r.strategy = :api
        r.description = 'listens'
      end

      def extract
        @proxy.recently_played(after: @config.since, limit: @config.limit, before: @config.until) do |item|
          yield build_extraction(data: item, meta: { agent: @agent })
        end
      end
    end
  end
end
