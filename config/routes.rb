Rails.application.routes.draw do
  root to: 'data_parse#trending'

  get '/trending' => 'data_parse#trending'

  get '/show/id/:tvdb_id' => 'data_parse#id'

  get '/show/name/:show_name' => 'data_parse#name'
end
