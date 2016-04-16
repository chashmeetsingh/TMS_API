module TrendingHelper

  def headers
    {
        'Content-Type' => 'application/json',
        'trakt-api-version' => '2',
        'trakt-api-key' => 'aec1b396a60919ff527a8137010c2da0e6ba48fece269d86158c860bfdc5f98b'
    }
  end

  def fanart_api_key
    '1c4a464a5219fdf0162eb19f8ba9a400'
  end

  def fanart_base_url
    'http://webservice.fanart.tv/v3/tv/'
  end
end
