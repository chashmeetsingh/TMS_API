Rails.application.routes.draw do
  root to: 'trending#shows'

  get 'trending/shows'
end
