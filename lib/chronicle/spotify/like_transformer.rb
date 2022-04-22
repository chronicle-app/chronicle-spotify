module Chronicle
  module Spotify
    class LikeTransformer < Chronicle::ETL::Transformer
      register_connector do |r|
        r.provider = 'spotify'
        r.description = 'a spotify track'
        r.identifier = 'like'
      end

      def transform
        build_liked
      end

      def id
        # No ID for the activity
      end

      def timestamp
        Time.parse(@extraction.data[:added_at])
      end

      private

      def track
        @track ||= @extraction.data[:track]
      end

      def actor
        @actor ||= @extraction.meta[:actor]
      end

      def build_liked
        record = ::Chronicle::ETL::Models::Activity.new({
          verb: 'liked',
          provider: 'spotify',
          end_at: timestamp
        })
        record.dedupe_on << [:provider, :verb, :end_at]
        record.actor = build_actor
        record.involved = build_track
        record
      end

      def build_track
        record = ::Chronicle::ETL::Models::Entity.new({
          represents: 'song',
          provider: 'spotify',
          provider_id: track[:id],
          title: track[:name],
        })

        record.creators = track[:artists].map{ |creator| build_creator(creator) }
        record.containers = build_album(track[:album])
        record.dedupe_on << [:provider, :provider_id, :represents]
        record
      end

      def build_creator(artist)
        record = ::Chronicle::ETL::Models::Entity.new({
          represents: 'musicartist',
          provider: 'spotify',
          provider_id: artist[:id],
          provider_url: artist[:external_urls][:spotify],
          title: artist[:name],
        })
        record.dedupe_on << [:provider_url]
        record.dedupe_on << [:provider, :provider_id, :represents]
        record
      end

      def build_album(album)
        record = ::Chronicle::ETL::Models::Entity.new({
          represents: 'album',
          provider: 'spotify',
          provider_id: album[:id],
          provider_url: album[:external_urls][:spotify],
          title: album[:name],
        })
        record.attachments = build_image(album[:images].first[:url])
        record.dedupe_on << [:provider_url]
        record.dedupe_on << [:provider, :provider_id, :represents]
        record
      end

      def build_image(image_url)
        record = ::Chronicle::ETL::Models::Attachment.new({
          url_original: image_url
        })
      end

      def build_actor
        record = ::Chronicle::ETL::Models::Entity.new({
          represents: 'identity',
          provider: 'spotify',
          provider_id: actor[:id],
          provider_url: actor[:external_urls][:spotify],
          slug: actor[:id],
          title: actor[:display_name]
        })
        record.dedupe_on << [:provider_url]
        record.dedupe_on << [:provider, :provider_id, :represents]
        record
      end

      def choose_verb
      end
    end
  end
end
