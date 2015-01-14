QAuthRubyClient::Engine.routes.draw do
  # -------------
  # Session pages
  # -------------

  root :to => 'sessions#sign_in'

  # Sign In URLs for users
  get     '/sign_in',         to: "sessions#sign_in",         as:  :sign_in
  get    '/create_session',   to: "sessions#create_session",  as:  :create_session

  # Logout Url
  delete  '/sign_out' ,       to: "sessions#sign_out",        as:  :sign_out
end
