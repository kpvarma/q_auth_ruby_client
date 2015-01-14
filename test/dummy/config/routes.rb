Rails.application.routes.draw do

  mount QAuthRubyClient::Engine => "/q_auth_ruby_client"
end
