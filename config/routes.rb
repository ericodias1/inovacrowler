Rails.application.routes.draw do
  # For search quote
  get 'quotes/:search_tag', to: 'quotes#search'
end
