require 'omniauth-oauth2'

module OmniAuth
  module Strategies
    class Nike < OmniAuth::Strategies::OAuth2
# https://api.nike.com/partner/auth/oauth/login.html?client_id=83c8d45cc211661c1a8c3cc90f50fbb0#83c8d45cc211661c1a8c3cc90f50fbb0/ODBlYzQ2ZDAtYmY0Ny00OWVjLTg5NWYtNzkyYjU3MTZjZjZm/http%3A%2F%2Flocalhost%3A3000%2Fusers%2Fnike_connect/en_US      
# https://api.nike.com/partner/auth/login?client_id=964c2f074f75c941df6cb0b24449bc73
# https://api.nike.com/partner/auth/oauth/create?access_token=c1d1fa6f2f8487428d9106eebaa2c02f&requesting_client_id=83c8d45cc211661c1a8c3cc90f50fbb0&third_party_user_id=ODBlYzQ2ZDAtYmY0Ny00OWVjLTg5NWYtNzkyYjU3MTZjZjZm
      option :client_options, {
        :site => 'https://api.nike.com/',
        :authorize_url => 'https://api.nike.com/partner/auth/oauth/login.html',
        :token_url => 'https://api.nike.com/partner/auth/login'
      }

      def request_phase
        super
      end

      uid { user_data['id'] }

      info do
        puts "info"
        puts request.inspect
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