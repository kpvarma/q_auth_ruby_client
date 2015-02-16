module QAuthRubyClient
  module SessionsHelper

    # Returns the default URL to which the system should redirect the user after successful authentication
    def default_redirect_url_after_sign_in
      QAuthRubyClient.configuration.default_redirect_url_after_sign_in
    end

    # Returns the default URL to which the system should redirect after the user successfully logout
    def default_redirect_url_after_sign_out
      QAuthRubyClient.configuration.default_redirect_url_after_sign_out
    end

    def redirect_url_after_sign_in
      params[:redirect_back_url] || default_redirect_url_after_sign_in
    end

    def redirect_to_sign_in_page
      respond_to do |format|
        format.html {
          redirect_to q_auth_ruby_client.sign_in_path
        }
        format.json { render json: {heading: @heading, alert: @alert} }
        format.js { render(:partial => 'sessions/redirect.js.erb', :handlers => [:erb], :formats => [:js]) }
      end
    end

    def update_user_profile_data_and_auth_token
      # Store the user object and Redirect to the Q-Auth sign in page with required params
      params_hsh = {client_app: QAuthRubyClient.configuration.q_app_name, redirect_back_url: create_session_url}
      url = add_query_params(QAuthRubyClient.configuration.q_auth_url, params_hsh)
      redirect_to url
    end

    # This method is widely used to create the @current_user object from the session
    # This method will return @current_user if it already exists which will save queries when called multiple times
    def current_user
      session[:qarc] = "true"
      return @current_user if @current_user
      # Check if the user exists with the auth token present in session
      @current_user = QAuthRubyClient::User.where("q_auth_uid = ?", session[:id]).first
    end

    # This method is usually used as a before filter to secure some of the actions which requires the user to be signed in.
    def require_user
      current_user
      if @current_user
        if @current_user.token_expired?
          @current_user = nil
          session.delete(:id)
          set_notification_messages(I18n.t("authentication.session_expired_heading"), I18n.t("authentication.session_expired_message"), :error)
          redirect_to_sign_in_page
          return
        end
      else
        set_notification_messages(I18n.t("authentication.permission_denied_heading"), I18n.t("authentication.permission_denied_message"), :error)
        redirect_to_sign_in_page
        return
      end
    end

    # This method is usually used as a before filter from admin controllers to ensure that the logged in user is an admin
    def require_admin
      unless (@current_user && @current_user.is_admin?)
        set_notification_messages(I18n.t("authentication.permission_denied_heading"), I18n.t("authentication.permission_denied_message"), :error)
        redirect_to_sign_in_page
        return
      end
    end

    # This method is usually used as a before filter from admin controllers to ensure that the logged in user is a super admin
    def require_super_admin
      unless @current_user.is_super_admin?
        set_notification_messages(I18n.t("authentication.permission_denied_heading"), I18n.t("authentication.permission_denied_message"), :error)
        redirect_to_sign_in_page
      end
    end

  end
end
