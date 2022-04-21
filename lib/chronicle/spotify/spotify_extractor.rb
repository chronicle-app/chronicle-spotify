module Chronicle
  module Spotify
    class SpotifyExtractor < Chronicle::ETL::Extractor
      setting :uid
      setting :access_token
      setting :refresh_token
      setting :client_id
      setting :client_secret

      def prepare
        @proxy = Proxy.new(
          uid: @config.uid,
          access_token: @config.access_token,
          refresh_token: @config.refresh_token,
          client_id: @config.client_id,
          client_secret: @config.client_secret
        )
      end
    end
  end
end
