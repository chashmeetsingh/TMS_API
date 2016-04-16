Rails.application.routes.draw do
  root to: 'trending#shows'

  get 'trending/shows'

  get '/show/id/:tvdb_id' => 'show#id'

  get '/show/name/:show_name' => 'show#name'
end
