class TrendingController < ApplicationController
  include TrendingHelper
  include ShowHelper

  def shows
    trending_show_url = 'https://api-v2launch.trakt.tv/shows/trending'

    response = HTTParty.get(trending_show_url, headers: headers)

    trending_object_response = Array.new

    response_json = JSON.parse(response.body)

    response_json.each do |trakt_trend_show_json|

      tvdb_show_id = trakt_trend_show_json['show']['ids']['tvdb'].to_s

      trakt_response = HTTParty.get(trakt_search_url_id(tvdb_show_id), headers: headers)

      trakt_json_response = JSON.parse(trakt_response.body)

      if !trakt_json_response.nil?
        trending_object_response << {
            show_title: trakt_trend_show_json['show']['title'],
            watchers_count: trakt_trend_show_json['watchers'],
            thumb_image_url:  trakt_json_response[0]['show']['images']['fanart']['thumb'],
            tvdb_id: trakt_trend_show_json['show']['ids']['tvdb'],
            overview: trakt_json_response[0]['show']['overview'],
            year: trakt_json_response[0]['show']['year'],
            status: trakt_json_response[0]['show']['status'],
            poster_image_url: trakt_json_response[0]['show']['images']['poster']['medium']
        }
      end
    end

    render json: {
        shows: trending_object_response
    }
  end
end
