require 'spec_helper'

class SitesHelperSpec
  extend SitesHelper
end

describe SitesHelper do
  context "#message_for_site" do
    it "should return correct message for OK site" do
      site = FactoryGirl.create(:ok_site)
      message = SitesHelperSpec::message_for_site(site)
      message.should == "ignition.hk is running"
    end
    
    it "should return correct message for FAILED site" do
      site = FactoryGirl.create(:failed_site)
      message = SitesHelperSpec::message_for_site(site)
      message.should == "ignition.hk is down since 3 minutes ago"
    end
    
    it "should return correct message for UNKNOWN site" do
      site = FactoryGirl.create(:site)
      message = SitesHelperSpec::message_for_site(site)
      message.should == "ignition.hk will be watched within 5 minutes"
    end
    
  end
end