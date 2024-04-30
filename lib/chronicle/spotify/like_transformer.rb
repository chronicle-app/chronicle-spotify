module Chronicle
  module Spotify
    class LikeTransformer < Chronicle::ETL::Transformer
      include Chronicle::Spotify::Builders

      register_connector do |r|
        r.source = :spotify
        r.type = :like
        r.strategy = :api
        r.description = 'a like'
        r.from_schema = :extraction
        r.to_schema = :chronicle
      end

      def transform(record)
        build_like(record: record.data, agent: record.extraction.meta[:agent])
      end
    end
  end
end
