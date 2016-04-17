class ShowController < ApplicationController
  include TrendingHelper
  include ShowHelper

  def id
    show_response = HTTParty.get(trakt_search_url_id(params[:tvdb_id
                                                     ]), headers: headers)

    getData(show_response)
  end

  def name
    show_response = HTTParty.get(trakt_search_url_name(params[:show_name]), headers: headers)

    getData(show_response)
  end

  def getData(show_response)
    show_json_response = show_response.body.length >= 2 ? JSON.parse(show_response.body) : nil

    show_results = Array.new

    show_json_response.each do |show|
      show_obj = show['show']
      poster_m_image_url = show_obj['images']['poster']['medium']
      tvdb_id = show_obj['ids']['tvdb'].to_s
      banner_image_url = ''

      unless poster_m_image_url.nil? or tvdb_id.nil?
        tvdb_response = HTTParty.get(tvdb_banner_url(tvdb_id))

        Hash.from_xml(tvdb_response.body)['Banners']['Banner'].each do |result|
          if result['BannerType'] == 'series' && result['BannerType2'] == 'graphical' && result['Language'] == 'en'
            banner_image_url = 'http://thetvdb.com/banners/' + result['BannerPath']
            break
          end
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

    render json: {
        results: show_results
    }
  end
end
