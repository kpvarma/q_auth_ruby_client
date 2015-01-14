# This will guess the User class
FactoryGirl.define do

  factory :user do
    sequence :name do |n|
      "User #{n}"
    end
    sequence :username do |n|
      "user#{n}"
    end
    sequence :email do |n|
      "user#{n}@yopmail.com"
    end

    sequence :q_auth_uid do |n|
      n
    end

    biography "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged."
    phone "1112 123456"
    skype "skype"
    linkedin "linkedin"

    city "city"
    state "state"
    country "country"

    department "department"
    designation "designation"

    auth_token {SecureRandom.hex}

    token_created_at { Time.now }

    user_type "user"

  end

  factory :admin_user, parent: :user do
    user_type "admin"
  end

  factory :super_admin_user, parent: :user do
    user_type "super_admin"
  end

end