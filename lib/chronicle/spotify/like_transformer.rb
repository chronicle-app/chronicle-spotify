module Chronicle
  module Spotify
    class LikeTransformer < Chronicle::ETL::Transformer
      include Chronicle::Spotify::Builders

      register_connector do |r|
        r.provider = 'spotify'
        r.description = 'a spotify track'
        r.identifier = 'like'
      end

      def transform
        build_liked(
          timestamp: timestamp,
          object: object,
          actor: @extraction.meta[:actor]
        )
      end

      def id
        object[:id]
      end

      def timestamp
        Time.parse(@extraction.data[:added_at])
      end

      private

      def object
        @object = @extraction.data[:track] || @extraction.data[:album]
      end
    end
  end
end
