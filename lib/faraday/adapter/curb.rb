module Faraday
  class Adapter
    class Curb < Faraday::Adapter
      dependency 'curb'

      # TODO Use Curl::Multi.
      # self.supports_parallel = true

      def client
        @client ||= ::Curl::Easy.new
      end

      def call(env)
        super

        req = env[:request]
        client.timeout = client.connect_timeout = req[:timeout] if req[:timeout]

        client.connect_timeout = req[:open_timeout] if req[:open_timeout]

        client.url = env[:url].to_s
        client.post_body = read_body(env)
        client.headers = env[:request_headers]

        case env[:method]
        when :head
          client.http_head
        else
          client.http env[:method].to_s.upcase.to_sym
        end

        save_response(env, client.response_code, client.body_str) do |response_headers|
          response_headers.parse client.header_str
        end

        @app.call(env)
      rescue ::Curl::Err::TimeoutError
        raise Faraday::Error::TimeoutError, $!
      end

    private

      def read_body(env)
        body = env[:body]
        body.respond_to?(:read) ? body.read : body
      end

    end
  end
end