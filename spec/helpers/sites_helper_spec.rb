require 'spec_helper'

class SitesHelperSpec
  extend SitesHelper
end

describe SitesHelper do
  context "#message_for_site" do
    it "should return correct message for OK site" do
      site = stub(:site)
      site.stub(:url => "http://ignition.hk", :status => "ok")
      
      message = SitesHelperSpec::message_for_site(site)
      message.should == "ignition.hk is running"
    end
    
    it "should return correct message for FAILED site" do
      site = stub(:site)
      site.stub(:url => "http://ignition.hk", :status => "failed", 
        :status_change_at => 3.minutes.ago)

      message = SitesHelperSpec::message_for_site(site)
      message.should == "ignition.hk is down since 3 minutes ago"
    end
    
  end
end