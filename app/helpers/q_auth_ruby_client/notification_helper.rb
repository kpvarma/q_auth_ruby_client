module QAuthRubyClient
  module NotificationHelper
    def set_notification_messages(heading, alert, not_type)
      @heading = heading
      @alert = alert
      set_flash_message("#{@heading}: #{@alert}", not_type) if defined?(flash) && flash
    end
  end
end
