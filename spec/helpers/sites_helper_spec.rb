require 'spec_helper'

class SitesHelperSpec
  extend SitesHelper
end

describe SitesHelper do
  context "#message_for_site" do
    it "should return correct message for OK site" do
      site = Factory.stub(:ok_site)
      message = SitesHelperSpec::message_for_site(site)
      message.should == "ignition.hk is running"
    end
    
    it "should return correct message for FAILED site" do
      site = Factory.stub(:failed_site)
      message = SitesHelperSpec::message_for_site(site)
      message.should == "ignition.hk is down since 3 minutes ago"
    end
    
    it "should return correct message for UNKNOWN site" do
      site = Factory.stub(:site)
      message = SitesHelperSpec::message_for_site(site)
      message.should == "ignition.hk will be watched soon"
    end
    
  end

  context "#validation_description" do
    site = Factory.stub(:site)
    site.content_validate_type = true
    site.content_validate_text = "Hello"
    SitesHelperSpec::validation_description(site).should == "Contains \"Hello\""
  
    site.content_validate_type = false
    site.content_validate_text = "Hello"
    SitesHelperSpec::validation_description(site).should == "Doesn't contains \"Hello\""
  end 
  
end