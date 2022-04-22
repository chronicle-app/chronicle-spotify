module Chronicle
  module Spotify
    class ListenTransformer < Chronicle::ETL::Transformer
      include Chronicle::Spotify::Builders

      register_connector do |r|
        r.provider = 'spotify'
        r.description = 'a spotify listen'
        r.identifier = 'listen'
      end

      def transform
        build_listen(
          timestamp: timestamp,
          track: @extraction.data[:track],
          actor: @extraction.meta[:actor]
        )
      end

      def id
        @extraction.data[:track][:id]
      end

      def timestamp
        Time.parse(@extraction.data[:played_at])
      end
    end
  end
end
