module Chronicle
  module Spotify
    module Builders
      def build_listen(track:, timestamp:, actor:)
        record = ::Chronicle::ETL::Models::Activity.new({
          verb: 'listened',
          provider: 'spotify',
          end_at: timestamp
        })
        record.dedupe_on << [:provider, :verb, :end_at]
        record.actor = build_actor(actor)
        record.involved = build_track(track)
        record
      end

      def build_liked(object:, timestamp:, actor:)
        record = ::Chronicle::ETL::Models::Activity.new({
          verb: 'liked',
          provider: 'spotify',
          end_at: timestamp
        })
        record.dedupe_on << [:provider, :verb, :end_at]
        record.actor = build_actor(actor)

        record.involved = if object[:album_type]
          build_album(object)
        else
          build_track(object)
        end

        record
      end

      def build_track(track)
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
        ::Chronicle::ETL::Models::Attachment.new({
          url_original: image_url
        })
      end

      def build_actor(actor)
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
    end
  end
end
