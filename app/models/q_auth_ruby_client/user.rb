class QAuthRubyClient::User < ActiveRecord::Base

  require 'typhoeus'

  self.table_name = 'users'

  # return an active record relation object with the search query in its where clause
  # Return the ActiveRecord::Relation object
  # == Examples
  #   >>> user.search(query)
  #   => ActiveRecord::Relation object
  scope :search, lambda {|query| where("LOWER(users.name) LIKE LOWER('%#{query}%') OR LOWER(users.username) LIKE LOWER('%#{query}%') OR LOWER(users.email) LIKE LOWER('%#{query}%') OR LOWER(users.phone) LIKE LOWER('%#{query}%') OR LOWER(users.city) LIKE LOWER('%#{query}%') OR LOWER(users.designation) LIKE LOWER('%#{query}%') OR LOWER(users.department) LIKE LOWER('%#{query}%')")}


  def self.fetch_all_users(auth_token)
    qauth_url = QAuthRubyClient.configuration.q_auth_url + "/api/v1/members"
    request = Typhoeus::Request.new(
      qauth_url,
      method: :get,
      headers: {"Authorization" => "Token token=#{auth_token}"},
      verbose: false
    )
    response = JSON.parse(request.run.body)

    if response["success"]
      response['data'].each do |data|
        user = find_in_cache(data)
        user.update_cache(data)
      end
    else
      raise
    end
  end

  def self.find_in_cache(data)
    # Checking if we already have this user(s) in our database
    users = QAuthRubyClient::User.where("auth_token = ? or username = ? or email = ? or q_auth_uid = ?", data['auth_token'], data['username'], data['email'], data['id']).all

    # Get the first user
    user = users.first

    if user
      # Corner Case : If there are (by chance) multiple rows, we need to remove them.
      #users.delete(user)
      #users.destroy if users.count > 0
      return user
    else
      # Create a new user
      QAuthRubyClient::User.new(auth_token: data['auth_token'], username: data['username'], email: data['email'], q_auth_uid: data['id'])
    end
  end

  def update_cache(data)
    self.name = data["name"]
    self.biography = data["biography"]
    self.phone = data["phone"]
    self.skype = data["skype"]
    self.linkedin = data["linkedin"]
    self.city = data["city"]
    self.state = data["state"]
    self.country = data["country"]

    self.auth_token = data["auth_token"]
    self.token_created_at = data["token_created_at"] || Time.now - 1.day
    self.user_type = data["user_type"]

    self.thumb_url = data.try(:[],"profile_image").try(:[],"thumb")
    self.medium_url = data.try(:[],"profile_image").try(:[],"medium")
    self.large_url = data.try(:[],"profile_image").try(:[],"large")
    self.original_url = data.try(:[],"profile_image").try(:[],"original")

    self.designation = data.try(:[],"designation").try(:[],"title")
    self.department = data.try(:[],"department").try(:[],"name")

    self.save if self.valid?
  end

  def self.create_session(auth_token)
    qauth_url = QAuthRubyClient.configuration.q_auth_url + "/api/v1/my_profile"
    request = Typhoeus::Request.new(
      qauth_url,
      method: :get,
      headers: {"Authorization" => "Token token=#{auth_token}"},
      verbose: false
    )
    response = JSON.parse(request.run.body)

    if response["success"]
      user = find_in_cache(response['data'])
      user.update_cache(response['data'])
      return user
    else
      return response
    end
  end

  def self.destroy_session(auth_token)
    qauth_url = QAuthRubyClient.configuration.q_auth_url + "/api/v1/sign_out"
    request = Typhoeus::Request.new(
      qauth_url,
      method: :delete,
      headers: {"Authorization" => "Token token=#{auth_token}"},
      verbose: false
    )
    response = JSON.parse(request.run.body)
    return response
  end

  def token_expired?
    return self.token_created_at.nil? || (Time.now > self.token_created_at + QAuthRubyClient.configuration.session_time_out)
  end

  # * Return address which includes city, state & country
  # == Examples
  #   >>> user.display_address
  #   => "Mysore, Karnataka, India"
  def display_address
    address_list = []
    address_list << city unless city.blank?
    address_list << state unless state.blank?
    address_list << country unless country.blank?
    address_list.join(", ")
  end

  # * Return true if the user is either a Q-Auth Super Admin or Q-Auth Admin
  # == Examples
  #   >>> user.is_admin?
  #   => true
  def is_admin?
    user_type == 'admin' || user_type == 'super_admin'
  end

  # * Return true if the user is either a Q-Auth Admin
  # == Examples
  #   >>> user.is_super_admin?
  #   => true
  def is_super_admin?
    user_type == 'super_admin'
  end

  # * Return true if the user is not activated, else false.
  # * inactive status will be there only for users who are not activated by user
  # == Examples
  #   >>> user.inactive?
  #   => true
  def inactive?
    (status == "inactive")
  end

  # * Return true if the user is activated, else false.
  # == Examples
  #   >>> user.active?
  #   => true
  def active?
    (status == "active")
  end

  # * Return true if the user is suspended, else false.
  # == Examples
  #   >>> user.suspended?
  #   => true
  def suspended?
    (status == "suspended")
  end
end
