Rails.application.routes.draw do
  post '/trending' => 'api#trending'

  post '/show/id/:tvdb_id/:trakt_id' => 'api#id'

  post '/show/name/:show_name' => 'api#name'
end
