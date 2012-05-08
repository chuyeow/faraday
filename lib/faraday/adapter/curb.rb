module Faraday
  class Adapter
    class Curb < Faraday::Adapter
      dependency 'curb'

      # TODO Use Curl::Multi.
      # self.supports_parallel = true

      def call(env)
        
      end
    end
  end
end