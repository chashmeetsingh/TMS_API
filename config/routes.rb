Rails.application.routes.draw do
  root to: 'api#trending'

  get '/trending' => 'api#trending'

  get '/show/id/:tvdb_id/:trakt_id' => 'api#id'

  get '/show/name/:show_name' => 'api#name'
end
