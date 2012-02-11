require 'spec_helper'

describe Site do
  context "Site has status" do
    it "should not ok nor fail when created" do
      site = FactoryGirl.create(:site)
      site.state.should == "unknown"
    end
    
    it "should be ok when called ok!" do
      site = FactoryGirl.create(:site)
      site.ok!
      site.state.should == "ok"
    end
    
    it "should be failed when called failed!" do
      site = FactoryGirl.create(:site)
      site.failed!
      site.state.should == "failed"
    end 
  end
end