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

end