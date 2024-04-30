require 'omniauth-spotify'

module Chronicle
  module Spotify
    class Authorizer < Chronicle::ETL::OauthAuthorizer
      provider :spotify
      omniauth_strategy :spotify
      scope %w[
        user-read-recently-played
        playlist-read-private
        playlist-read-collaborative
        user-read-private
        user-read-email
        user-library-read
      ].join(' ')
      pluck_secrets({
        access_token: %i[credentials token],
        refresh_token: %i[credentials refresh_token],
        uid: [:uid],
        name: %i[info name],
        email: %i[info email]
      })
    end
  end
end
