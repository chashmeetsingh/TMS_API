class ShowController < ApplicationController
  include TrendingHelper
  include ShowHelper

  def id
    require 'open-uri'
    require 'crack/xml'

    xml_data = HTTParty.get(tvdb_get_show_url(params[:tvdb_id]))

    xml_to_json = Crack::XML.parse(xml_data.body)

    base_obj = xml_to_json['Data']['Series']

    all_seasons = Array.new
    default_season_no = 0

    single_season = Array.new
    xml_to_json['Data']['Episode'].each do |episode|
      if episode['filename'].nil?
        image_url = nil
      else
        image_url = 'http://www.thetvdb.com/banners/' + episode['filename']
      end
      if episode['EpisodeName'].nil?
        episode_name = 'TBA'
      else
        episode_name = episode['EpisodeName']
      end

      #puts episode

      #puts episode['FirstAired']

      if !episode['FirstAired'].nil?
        show_air_time = episode['FirstAired'] + ' ' + base_obj['Airs_Time']
        #puts show_air_time
        begin
          new_time = Time.strptime(show_air_time, '%Y-%m-%d %I:%M %p')
        rescue
          new_time = Time.strptime(show_air_time, '%Y-%m-%d %I:%M%p')
        end
        new_time = new_time.strftime('%d-%m-%Y %I:%M %p')
      else
        new_time = nil
      end

      #puts new_time

      if episode['Combined_season'].to_i == default_season_no
        single_season << {
            title: episode_name,
            air_date_time: new_time,
            overview: episode['Overview'],
            image: image_url,
            rating: episode['Rating'],
            writer: episode['Writer'],
            watched: false
        }
      else
        default_season_no += 1
        all_seasons <<  single_season
        single_season = []
        single_season << {
            title: episode_name,
            air_date_time: new_time,
            overview: episode['Overview'],
            image: image_url,
            rating: episode['Rating'],
            writer: episode['Writer'],
            watched: false
        }
      end
    end
    all_seasons << single_season

    series_object = {
        id: base_obj['id'],
        title: base_obj['SeriesName'],
        actors: base_obj['Actors'],
        genre: base_obj['Genre'],
        first_aired: base_obj['FirstAired'],
        air_time: base_obj['Airs_Time'],
        network: base_obj['Network'],
        overview: base_obj['Overview'],
        rating: base_obj['Rating'],
        runtime: base_obj['Runtime'],
        status: base_obj['Status'].titleize,
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
            status: show_obj['status'].titleize,
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
