module ApiHelper

  def trending_show_url
    'https://api-v2launch.trakt.tv/shows/trending?limit=20'
  end

  def headers
    {
      'Content-Type' => 'application/json',
      'trakt-api-version' => '2',
      'trakt-api-key' => ENV['trakt_api_key']
    }
  end

  def tvdb_url
    'http://thetvdb.com/api/' + ENV['tvdb_api_key'] + '/series/'
  end

  def search_url(id)
    'https://api-v2launch.trakt.tv/search?id_type=tvdb&id=' + id.to_s
  end

  def show_url(id)
    tvdb_url + id + '/all'
  end

  def image_base_url
    'http://www.thetvdb.com/banners/'
  end

  def search_url_name(show_name)
    'https://api-v2launch.trakt.tv/search?type=show&query=' + show_name
  end

  def tvdb_banner_url(tvdb_id)
    tvdb_url + tvdb_id.to_s + '/banners.xml'
  end

  def timezone_url(trakt_id)
    'https://api-v2launch.trakt.tv/shows/' + trakt_id.to_s + '?extended=full'
  end
end
