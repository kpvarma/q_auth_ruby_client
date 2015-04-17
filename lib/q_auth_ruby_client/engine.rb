module QAuthRubyClient
  class Engine < ::Rails::Engine
    isolate_namespace QAuthRubyClient

    initializer "q_auth_ruby_client.configure_rails_initialization" do |app|
      ActiveSupport.on_load :action_controller do
        include QAuthRubyClient::ApplicationHelper
        include QAuthRubyClient::ApiHelper
        include QAuthRubyClient::NotificationHelper
        include QAuthRubyClient::SessionsHelper
        helper QAuthRubyClient::ApplicationHelper
        helper QAuthRubyClient::ApiHelper
        helper QAuthRubyClient::NotificationHelper
        helper QAuthRubyClient::SessionsHelper
      end

      config.to_prepare do
        Dir.glob(Rails.root + "app/decorators/**/*_decorator*.rb").each do |c|
          require_dependency(c)
        end
      end
    end
  end
end
