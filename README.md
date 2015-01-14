= QAuthRubyClient

This is a ruby client for Q-Auth Application

Step 0 : Add 127.0.0.1 lvh.me to /etc/hosts file
This is done to ensure that we are using single session with cookie for all the applications runnign on different ports for development

Step 1 : Add q_auth_ruby_client to Gemfile

q_auth_ruby_client internaally requires poodle to function.
Poodle has some good helper methods which this client uses.

gem 'q_auth_ruby_client'
gem 'poodle'

Step 2 : Bundle install

$ bundle install

Step 3 : Mount Q-Auth Ruby Client Engine

Add the following line to routes.rb

# Mounting Q-Auth Ruby Client Engine
mount QAuthRubyClient::Engine, at: "/q-auth", :as => 'q_auth_ruby_client'

root :to => 'q_auth_ruby_client/sessions#sign_in'

Step 4 : Configure Q-Auth Ruby Client

Create 'q_auth_ruby_client.rb' in 'config/initializers' and add
the following content into it.

QAuthRubyClient.configure do |config|
  config.q_app_name = "Q-Meeting"
  config.default_redirect_url_after_sign_in = "/user/dashboard"
end

You can configure the following ones.

1. user_status_list
2. q_app_name
3. q_auth_url
4. q_projects_url
5. q_time_url
6. q_meeting_url
7. default_redirect_url_after_sign_in
8. my_profile_url
9. session_time_out

Step 5 : Add / Change the sign out url to




