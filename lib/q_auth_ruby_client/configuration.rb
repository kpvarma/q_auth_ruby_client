module QAuthRubyClient
  class Configuration
    attr_accessor :user_status_list,
                  :q_app_name,
                  :q_auth_url,
                  :q_projects_url,
                  :q_time_url,
                  :q_meeting_url,
                  :default_redirect_url_after_sign_in,
                  :default_redirect_url_after_sign_out,
                  :my_profile_url,
                  :session_time_out

    def initialize
      @session_time_out = 60.minutes
      @q_app_name = "Q Auth App"
      @q_auth_url = ENV["QAUTH_URL"] || "http://localhost:9001"
      @q_projects_url = ENV["QPROJECTS_URL"] || "http://localhost:9002"
      @q_time_url = ENV["QTIME_URL"] || "http://localhost:9003"
      @q_meeting_url = ENV["QMEETING_URL"] || "http://localhost:9004"

      @default_redirect_url_after_sign_in = "/dashboard"
      @default_redirect_url_after_sign_out = "/"
      @my_profile_url = "/user/profile"
      @default_sign_in_url = "/sign_in"
    end

  end
end