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
  
  context "#content_valid_description" do
    site = FactoryGirl.create(:site)
    site.content_validate_type = true
    site.content_validate_text = "Hello"
    site.content_valid_description.should == "Contains \"Hello\""

    site.content_validate_type = false
    site.content_validate_text = "Hello"
    site.content_valid_description.should == "Doesn't contains \"Hello\""
  end
  
  context "#content_valid? to find if a page content is valid" do
    let(:site) { FactoryGirl.create(:site) }

    it "should find page that not contains specific keyword" do
      site.content_validate_type = false
      site.content_validate_text = "error"
      site.save!

      site.content_valid?("error not found").should be_false
      site.content_valid?("pass test").should be_true
    end
    
    it "should find page that contains specific keyword" do
      site.content_validate_type = true
      site.content_validate_text = "pass"
      site.save!

      site.content_valid?("error not found").should be_false
      site.content_valid?("pass test").should be_true
    end
    
    it "should just pass check if lookup type or text is not defined" do
      site.content_validate_type = nil
      site.content_validate_text = ""
      site.save!
      site.content_valid?("error not found").should be_true
      site.content_valid?("pass test").should be_true 
      
      site.content_validate_type = nil
      site.content_validate_text = "Hello World"
      site.save!
      site.content_valid?("error not found").should be_true
      site.content_valid?("pass test").should be_true
      
      site.content_validate_type = true
      site.content_validate_text = ""
      site.save!
      site.content_valid?("error not found").should be_true
      site.content_valid?("pass test").should be_true

      site.content_validate_type = false
      site.content_validate_text = ""
      site.save!
      site.content_valid?("error not found").should be_true
      site.content_valid?("pass test").should be_true
      
    end
    
  end
end