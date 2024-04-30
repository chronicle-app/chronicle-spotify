require 'chronicle/models'

module Chronicle
  module Spotify
    module Builders
      def build_listen(record:, agent:)
        Chronicle::Models::ListenAction.new do |r|
          r.end_time = record[:played_at]
          r.object = build_track(record[:track])
          r.agent = build_agent(agent)
          r.source = 'spotify'
          r.dedupe_on << %i[type source end_time]
        end
      end

      def build_like(record:, agent:)
        Chronicle::Models::LikeAction.new do |r|
          r.end_time = record[:added_at]

          r.object = if record[:album]
                       build_album(record[:album])
                     elsif record[:track]
                       build_track(record[:track])
                     end

          r.agent = build_agent(agent)
          r.source = 'spotify'
          r.dedupe_on << %i[type source end_time]
        end
      end

      def build_track(track)
        Chronicle::Models::MusicRecording.new do |r|
          r.name = track[:name]
          r.in_album = [build_album(track[:album])]
          r.by_artist = track[:artists].map { |artist| build_artist(artist) }
          r.duration = "PT#{track[:duration_ms] / 1000.0}S"
          r.source = 'spotify'
          r.source_id = track[:id]
          r.dedupe_on = [[:url], %i[source_id source type]]
        end
      end

      def build_artist(artist)
        Chronicle::Models::MusicGroup.new do |r|
          r.name = artist[:name]
          r.url =  artist[:external_urls][:spotify]
          r.source = 'spotify'
          r.source_id = artist[:id]
        end
      end

      def build_album(album)
        Chronicle::Models::MusicAlbum.new do |r|
          r.name = album[:name]
          r.source = 'spotify'
          r.source_id = album[:id]
          r.image = album[:images].first[:url]
          r.url = album[:external_urls][:spotify]
        end
      end

      def build_agent(agent)
        Chronicle::Models::Person.new do |r|
          r.name = agent[:display_name]
          r.url = agent[:external_urls][:spotify]
          r.source = 'spotify'
          r.slug = agent[:id]
          r.source_id = agent[:id]
        end
      end
    end
  end
end
