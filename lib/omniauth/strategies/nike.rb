require 'omniauth-oauth2'

module OmniAuth
  module Strategies
    class Nike < OmniAuth::Strategies::OAuth2
      option :client_options, {
        :site => 'https://api.angel.co/',
        :authorize_url => 'https://angel.co/api/oauth/authorize',
        :token_url => 'https://angel.co/api/oauth/token'
      }

      def request_phase
        super
      end

      uid { user_data['id'] }

      info do
        {
          'email' => user_data['email'],
          'name' => user_data['name'],
          'image' => user_data['image'],
          'urls' => {
            'AngelList' => user_data['angellist_url'],
            'Website' => user_data['online_bio_url']
          },
        }
      end

      def user_data
        access_token.options[:mode] = :query
        user_data ||= access_token.get('/1/me').parsed
      end

    end
  end
end

OmniAuth.config.add_camelization 'angellist', 'AngelList'