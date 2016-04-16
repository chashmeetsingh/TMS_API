module ShowHelper

  def trakt_search_url(show_name)
    'https://api-v2launch.trakt.tv/search?type=show&query=' + show_name
  end
end
