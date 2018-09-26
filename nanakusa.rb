require 'net/http'
require 'uri'
require 'json'
require 'logger'

logger = Logger.new('./webapi.log')

params = "create"
uri = URI.parse("http://localhost:3000/api/posts##{params}")

def get_index
  begin
    response = Net::HTTP.start(uri.host, uri.port) do |http|
      http.open_timeout = 5
      http.read_timeout = 10
      http.get(uri.request_uri)
    end

    case response

    when Net::HTTPSuccess
      p JSON.parse(response.body)

    when Net::HTTPRedirection
      logger.warn("Redirection: code=#{response.code} message=#{response.message}")
      logger.error("HTTP ERROR: code=#{response.code} message=#{response.message}")
      
    else
      logger.error("HTTP ERROR: code=#{response.code} message=#{response.message}")

    end
  rescue IOError => e
    logger.error(e.message)
  rescue TimeoutError => e
    logger.error(e.message)
  rescue JSON::ParserError => e
    logger.error(e.message)
  rescue => e
    logger.error(e.message)
  end
end

def post_post(uri)
  http = Net::HTTP.new(uri.host, uri.port)

  req = Net::HTTP::Post.new(uri.path)
  req.set_form_data({'title' => 'TitlePOST', 'description' => 'DescriptionPOST', 'body' => 'BodyPOST', 'likes' => '0'})

  res = http.request(req)
end

post_post(uri)
