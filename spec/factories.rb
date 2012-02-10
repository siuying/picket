FactoryGirl.define do
  factory :site do
    url 'http://ignition.hk'

    factory :failed_site do
      status "failed"
      status_changed_at { 3.minutes.ago }
      message "Failed"
    end
  
    factory :ok_site do
      status "ok"
      status_changed_at { 3.minutes.ago }
    end
    
  end
end