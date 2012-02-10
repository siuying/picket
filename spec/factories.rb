FactoryGirl.define do
  factory :site do
    url 'http://ignition.hk'
    state :unknown
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