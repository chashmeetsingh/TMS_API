class ShowController < ApplicationController
  include TrendingHelper
  include ShowHelper

  def id
    require 'open-uri'
    require 'crack/xml'
    puts tvdb_get_show_url(params[:tvdb_id])
    xml_data = HTTParty.get(tvdb_get_show_url(params[:tvdb_id]))

    show_object = Array.new
    xml_to_json = Crack::XML.parse(xml_data.body)

    base_obj = xml_to_json['Data']['Series']

    all_seasons = Array.new
    default_season_no = 0

    single_season = Array.new
    xml_to_json['Data']['Episode'].each do |episode|
      if episode['Combined_season'].to_i == default_season_no
        single_season << {
            episode_name: episode['EpisodeName'],
            air_date: episode['FirstAired'],
            overview: episode['Overview'],
            image: 'http://www.thetvdb.com/banners/' ,
            rating: episode['Rating'],
            writer: episode['Writer']
        }
      else
        default_season_no += 1
        season = 'Season ' + default_season_no.to_s
        all_seasons <<  single_season
        single_season = []
        single_season << {
            episode_name: episode['EpisodeName'],
            air_date: episode['FirstAired'],
            overview: episode['Overview'],
            image: 'http://www.thetvdb.com/banners/',
            rating: episode['Rating'],
            writer: episode['Writer']
        }
      end

    end
    all_seasons << single_season

    series_object = {
        series_name: base_obj['SeriesName'],
        actors: base_obj['Actors'],
        genre: base_obj['Genre'],
        first_aired: base_obj['FirstAired'],
        air_time: base_obj['Airs_Time'],
        airs_day_of_the_week: base_obj['Airs_DayOfWeek'],
        network: base_obj['Network'],
        overview: base_obj['Overview'],
        rating: base_obj['Rating'],
        runtime: base_obj['Runtime'],
        status: base_obj['Status'],
        banner: 'http://www.thetvdb.com/banners/' + base_obj['banner'],
        fanart: 'http://www.thetvdb.com/banners/' + base_obj['fanart'],
        poster: 'http://www.thetvdb.com/banners/' + base_obj['poster'],
        seasons: all_seasons
    }

    #render json: Crack::XML.parse(xml_data.body)
    render json: series_object
  end

  def name
    show_response = HTTParty.get(trakt_search_url_name(params[:show_name]), headers: headers)

    getData(show_response)
  end

  def getData(show_response)
    require 'open-uri'
    require 'nokogiri'
    show_json_response = show_response.body.length >= 2 ? JSON.parse(show_response.body) : nil

    show_results = Array.new

    show_json_response.each do |show|
      show_obj = show['show']
      poster_m_image_url = show_obj['images']['poster']['medium']
      tvdb_id = show_obj['ids']['tvdb'].to_s
      banner_image_url = ''

      unless poster_m_image_url.nil? or tvdb_id.nil?

        response = Nokogiri::XML(open(tvdb_banner_url(tvdb_id)))
        response.css('Banner').each do |obj|
          if obj.xpath('Language').inner_text == 'en' && obj.xpath('BannerType2').inner_text == 'graphical'
            banner_image_url = 'http://thetvdb.com/banners/' + obj.xpath('BannerPath').inner_text
            break
          end
        end

      end

      unless banner_image_url.empty? or show_obj['year'].nil?
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
