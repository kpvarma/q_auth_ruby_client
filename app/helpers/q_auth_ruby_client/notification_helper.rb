module QAuthRubyClient
  module NotificationHelper
    def set_notification_messages(heading, alert, now_type)
      @heading = heading
      @alert = alert
      set_flash_message("#{@heading}: #{@alert}", now_type) if defined?(flash) && flash
    end
  end
end
