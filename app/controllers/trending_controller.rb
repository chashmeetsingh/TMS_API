class TrendingController < ApplicationController
  include TrendingHelper

  def shows
    trending_show_url = 'https://api-v2launch.trakt.tv/shows/trending'

    response = HTTParty.get( trending_show_url, headers: headers)

    trending_object_response = Array.new

    response_json = JSON.parse(response.body)

    response_json.each do |trakt_trend_show_json|

      tvdb_show_id = trakt_trend_show_json['show']['ids']['tvdb'].to_s

      fanart_show_url = fanart_base_url + tvdb_show_id + '?api_key=' + fanart_api_key

      fanart_show_response = HTTParty.get(fanart_show_url)
      fanart_json_response =  JSON.parse(fanart_show_response.body)

      image_url = ''

      fanart_json_response['tvbanner'].each do |image|
        if image['lang'] == 'en'
          image_url = image['url']
          break
        end
      end

      trending_object_response << {
          show_title: trakt_trend_show_json['show']['title'],
          watchers_count: trakt_trend_show_json['watchers'],
          image_url: image_url,
          tvdb_id: trakt_trend_show_json['show']['ids']['tvdb']
      }
    end

    render json: {
        shows: trending_object_response
    }
  end
end
