class ShowController < ApplicationController
  include TrendingHelper
  include ShowHelper

  def id
    show_response = HTTParty.get(trakt_search_url_id(params[:tvdb_id]), headers: headers)

    getData(show_response)
  end

  def name
    show_response = HTTParty.get(trakt_search_url_name(params[:show_name]), headers: headers)

    getData(show_response)
  end

  def getData(show_response)
    show_json_response = JSON.parse(show_response.body)

    show_results = Array.new

    show_json_response.each do |show|
      show_obj = show['show']
      poster_m_image_url = show_obj['images']['poster']['medium']
      tvdb_id = show_obj['ids']['tvdb'].to_s
      unless poster_m_image_url.nil? or tvdb_id.nil?

        fanart_show_url = fanart_base_url + tvdb_id + '?api_key=' + fanart_api_key
        fanart_show_response = HTTParty.get(fanart_show_url, headers: headers)
        fanart_json_response = JSON.parse(fanart_show_response.body)

        banner_image_url = ''
        unless fanart_json_response['status'] or !fanart_json_response['tvbanner']
          fanart_json_response['tvbanner'].each do |image|
            if image['lang'] == 'en'
              banner_image_url = image['url']
              break
            end
          end

          if !banner_image_url.empty?
            show_results << {
                title: show_obj['title'],
                overview: show_obj['overview'],
                year: show_obj['year'],
                status: show_obj['status'],
                tvdb_id: show_obj['ids']['tvdb'],
                banner: banner_image_url,
                poster: poster_m_image_url
            }
          end
        end
      end
    end

    render json: {
        results: show_results
    }
  end
end
