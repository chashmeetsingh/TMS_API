module ShowHelper

  def trakt_search_url_name(show_name)
    'https://api-v2launch.trakt.tv/search?type=show&query=' + show_name
  end

  def trakt_search_url_id(id)
    'https://api-v2launch.trakt.tv/search?id_type=tvdb&id=' + id.to_s
  end

  def tvdb_banner_url(tvdb_id)
    'http://thetvdb.com/api/9DD79C4EF5C3AE90/series/' + tvdb_id + '/banners.xml'
  end
end
