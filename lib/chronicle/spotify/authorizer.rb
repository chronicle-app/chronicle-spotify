require 'omniauth-spotify'

module Chronicle
  module Spotify
    class Authorizer < Chronicle::ETL::OauthAuthorizer
      provider :spotify
      omniauth_strategy :spotify
      scope 'user-read-recently-played playlist-read-private playlist-read-collaborative user-read-private user-read-email user-library-read'
      pluck_secrets({ 
        access_token: [:credentials, :token],
        refresh_token: [:credentials, :refresh_token],
        uid: [:uid],
        name: [:info, :name],
        email: [:info, :email],
      })
    end
  end
end
