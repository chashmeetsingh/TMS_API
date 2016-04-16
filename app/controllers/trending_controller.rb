class TrendingController < ApplicationController

  def shows

    trending_show_url = 'https://api-v2launch.trakt.tv/shows/trending'
    trakt_api_key = '1c4a464a5219fdf0162eb19f8ba9a400'
    trakt_base_url = 'http://webservice.fanart.tv/v3/tv/'

    response = HTTParty.get( trending_show_url, headers: {
        'Content-Type' => 'application/json',
        'trakt-api-version' => '2',
        'trakt-api-key' => 'aec1b396a60919ff527a8137010c2da0e6ba48fece269d86158c860bfdc5f98b'
    })

    trending_object_response = Array.new

    response_json = JSON.parse(response.body)

    response_json.each do |json_onj|

      trakt_show_id = json_onj['show']['ids']['tvdb'].to_s

      trakt_show_url = trakt_base_url + trakt_show_id + '?api_key=' + trakt_api_key

      trakt_show_response = HTTParty.get(trakt_show_url)
      trakt_json_response =  JSON.parse(trakt_show_response.body)

      image_url = ''

      trakt_json_response['tvbanner'].each do |image|
        if image['lang'] == 'en'
          image_url = image['url']
          break
        end
      end

      trending_object_response << {
          show_title: json_onj['show']['title'],
          watchers_count: json_onj['watchers'],
          image_url: image_url,

      }
    end

    render json: {
        shows: trending_object_response
    }
  end
end
