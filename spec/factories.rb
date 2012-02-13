FactoryGirl.define do  
  factory :bob, :class => "User" do
    email "bob@ignition.hk"
    password "password"
    password_confirmation {|u| u.password }
  end
  
  factory :alice, :class => "User" do
    email "alice@ignition.hk"
    password "password"
    password_confirmation {|u| u.password }
  end
  
  factory :user do
    sequence (:email) {|n| "user#{n}@ignition.hk" }
    password "password"
    password_confirmation {|u| u.password }
  end

  factory :site do
    url 'http://ignition.hk'
    state :unknown
    association(:user) { Factory.next(:user) }
  end

  factory :failed_site, :parent => :site do
    state :failed
    failed_at { 3.minutes.ago }
    message "Failed"
  end
  
  factory :ok_site, :parent => :site do
    state :ok
    failed_at { 3.minutes.ago }
  end
  
  factory :validate_site, :parent => :ok_site do
    content_validate_type true
    content_validate_text "Hello"
  end
  

end