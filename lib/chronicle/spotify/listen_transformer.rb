module Chronicle
  module Spotify
    class ListenTransformer < Chronicle::ETL::Transformer
      include Chronicle::Spotify::Builders

      register_connector do |r|
        r.source = :spotify
        r.type = :listen
        r.strategy = :api
        r.description = 'a listen'
        r.from_schema = :extraction
        r.to_schema = :chronicle
      end

      def transform(record)
        build_listen(record: record.data, agent: record.extraction.meta[:agent])
      end
    end
  end
end
