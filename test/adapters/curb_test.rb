require File.expand_path('../integration', __FILE__)

module Adapters
  class CurbTest < Faraday::TestCase

    def adapter() :curb end

    Integration.apply(self, :NonParallel) do
      # Curb doesn't support GET requests with body.
      undef :test_GET_with_body

      def test_binds_local_socket
        host = '1.2.3.4'
        conn = create_connection :request => { :bind => { :host => host } }
        assert_equal host, conn.options[:bind][:host]
      end
    end

    # TODO When parallelism is implemented.
    # Integration.apply(self, :Parallel) do
    # end
  end
end
