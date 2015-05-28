module Janky
  module Builder
    class HTTP
      def initialize(username, password)
        @username = username
        @password = password
      end

      def run(params, create_url)
        http     = Net::HTTP.new(create_url.host, create_url.port)
        if create_url.scheme == "https"
          http.use_ssl = true
        end

        puts "run: create_url: #{create_url}; path: #{create_url.path}"

        request  = Net::HTTP::Post.new(create_url.path)
        if @username && @password
          request.basic_auth(@username, @password)
        end
        request.form_data = {"json" => params}

        puts "run: request: #{request.inspect}"

        response = http.request(request)

        puts "run: response: #{response.inspect}"

        if !%w[302 201].include?(response.code)
          Exception.push_http_response(response)
          raise Error, "Failed to create build"
        end
      end

      def output(url)
        puts "Janky::Builder::HTTP#output: url: #{url}"

        http     = Net::HTTP.new(url.host, url.port)
        if url.scheme == "https"
          http.use_ssl = true
        end

        request  = Net::HTTP::Get.new(url.path)
        if @username && @password
          request.basic_auth(@username, @password)
        end

        puts "Janky::Builder::HTTP#output: request: #{request}"

        response = http.request(request)

        unless response.code == "200"
          Exception.push_http_response(response)
          raise Error, "Failed to get build output"
        end

        response.body
      end
    end
  end
end
