# frozen_string_literal: true

module GnresolverClient
  # Engine-connector to the gnresolver service
  module Engine
    HEADERS = { content_type: :json, accept: :json }.freeze

    class << self
      def connected?
        !query(method: :get, path: "version").nil?
      end

      def query(opts)
        url, params = url_params(opts)
        resp = post?(opts[:method]) ? post(url, params) : get(url, params)
        resp = JSON.parse(resp.body, symbolize_names: true) if resp
        block_given? ? yield(resp) : resp
      end

      def url_params(opts)
        opts = { method: "post", path: "" }.merge(opts)
        url = GnresolverClient.conf.url + opts[:path]
        params = HEADERS.merge(params: opts[:params])
        [url, params]
      end

      def post?(method)
        method.to_s.match(/post/i)
      end

      def post(url, params)
        request(:post, url, params)
      end

      def get(url, params)
        request(:get, url, params)
      end

      def request(method, url, params)
        RestClient.send(method, url, params) do |resp, _req, _res|
          resp.code == 200 ? resp : nil
        end
      end

      def normalize_type(type)
        type = type.to_s
        return type if IdigbioClient.types.include?(type)
        sym_types = types.map { |t| ":#{t}" }.join(", ")
        raise "Unknown type :#{type}. Types: #{sym_types}"
      end

      def symbolize(h)
        h.keys.each do |k|
          sym = k.to_sym
          h[sym] = h.delete(k)
          symbolize(h[sym]) if h[sym].is_a? Hash
        end
      end
    end
  end
end
