require 'rspotify'

module Chronicle
  module Spotify
    class Proxy
      PER_PAGE = 50

      def initialize(access_token:, refresh_token:, client_id:, client_secret:, uid:)
        auth_hash = {
          'credentials' => {
            'token' => access_token,
            'refresh_token' => refresh_token
          },
          'id' => uid
        }
        RSpotify.authenticate(client_id, client_secret)
        RSpotify.raw_response = true
        @authenticated_user = RSpotify::User.new(auth_hash)
      end

      def user
        JSON.parse(RSpotify::User.find(@authenticated_user.id), symbolize_names: true)
      end

      def saved_albums(limit:, after: nil, &block)
        retrieve_all(method: :saved_albums, after:, limit:, &block)
      end

      def saved_tracks(limit:, after: nil, &block)
        retrieve_all(method: :saved_tracks, after:, limit:, &block)
      end

      def recently_played(before: nil, after: nil, limit: nil, &block)
        before = before&.to_i&.*(1000)
        retrieve_all(method: :recently_played, before:, after:, limit:, &block)
      end

      private

      def retrieve_all(method:, before: nil, after: nil, limit: nil, &block)
        has_more = true
        count = 0
        offset = 0 if method != :recently_played # FIXME: hacky

        while has_more
          response = retrieve_page(method:, before:, offset:)

          records = response[:items]
          records = records.first(limit - count) if limit
          records = records.filter { |record| Time.parse(record[:added_at] || record[:played_at]) > after } if after

          break unless records.any?

          records.each(&block)

          count += records.count
          has_more = response[:next]
          # Available for recently_played
          before = response.dig(:cursors, :before)
          offset += PER_PAGE if offset
        end
      end

      def retrieve_page(method:, before: nil, offset: nil)
        options = {
          offset:,
          limit: PER_PAGE,
          before:
        }.compact

        JSON.parse(@authenticated_user.send(method, **options), symbolize_names: true)
      end
    end
  end
end
