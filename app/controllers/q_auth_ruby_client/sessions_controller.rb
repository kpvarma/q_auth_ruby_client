class QAuthRubyClient::SessionsController < ApplicationController

  before_filter :require_user, :only => :sign_out
  before_filter :set_navs

  def sign_in
    if current_user
      if current_user.token_expired?
        update_user_profile_data_and_auth_token
        return
      else
        redirect_to redirect_url_after_sign_in
        return
      end
    else
      update_user_profile_data_and_auth_token
      return
    end
  end

  def create_session
    response = QAuthRubyClient::User.create_session(params[:auth_token])
    if response.is_a?(QAuthRubyClient::User)
      @current_user = response
      session[:id] = @current_user.q_auth_uid unless session[:id]
      set_notification_messages(I18n.t("authentication.logged_in_successfully_heading"), I18n.t("authentication.logged_in_successfully_message"), :success)
      redirect_to default_redirect_url_after_sign_in
    else
      raise response["errors"]["name"]
    end
  end

  def sign_out

    store_flash_message("You have successfully signed out", :notice)

    # Reseting the auth token for user when he logs out.
    # @current_user.update_attribute :auth_token, SecureRandom.hex

    session.delete(:id)

    redirect_to default_redirect_url_after_sign_out
  end

  private

  def set_navs
    set_nav("Login")
  end
end
