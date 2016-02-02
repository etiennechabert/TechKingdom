require "epitech_api/version"
require "uri"
require "open-uri"

module EpitechApi

    API_URL = 'http://ws.paysdu42.fr'
    FORMAT = 'JSON'

    def self.authentification(login, pass)
        params =
            {
                action: 'check_password',
                auth_login: EPITECH_API_LOGIN,
                auth_password: EPITECH_API_PASSWORD,
                login: login,
                password: pass
            }
        JSON.parse execute_http_request params
    end

    def self.get_details(login)
        params =
            {
                action: 'get_name',
                auth_login: EPITECH_API_LOGIN,
                auth_password: EPITECH_API_PASSWORD,
                login: login,
            }
        JSON.parse execute_http_request params
    end

    private

    def self.execute_http_request(params)
        uri = URI.parse "#{API_URL}/#{FORMAT}"
        uri.query = URI.encode_www_form params
        uri.open.read
    end
end
