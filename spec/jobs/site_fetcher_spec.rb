require 'spec_helper'

describe SiteFetcher do
  before(:each) do
    SitesMailer = double(:sites_mailer).as_null_object
    @response = double(:response)
    @response.stub(:body).and_return("anything")
    SiteFetcher.stub(:get_url).and_return(@response)     
  end

  context "fetch page and notify if needed" do
    it "should not send when status is ok and no change" do
      @site = FactoryGirl.create(:ok_site)
      @response.stub(:success?).and_return(true)
      SitesMailer.should_not_receive(:notify_error).should_not_receive(:notify_resolved)

      SiteFetcher.perform(@site.id)
    end

    it "should send when status is change from ok to fail" do
      @site = FactoryGirl.create(:ok_site)
      @response.stub(:success? => false, :timed_out? => false, :code => 404, :status_message => "Not found")
      SitesMailer.should_receive(:notify_error).and_return(stub(:mailer, :deliver => true))
      SitesMailer.should_not_receive(:notify_resolved)

      SiteFetcher.perform(@site.id)
    end
    
    it "should send when status is change from fail to ok" do
      @site = FactoryGirl.create(:failed_site)
      @response.stub(:success?).and_return(true) 
      SitesMailer.should_receive(:notify_resolved).and_return(stub(:mailer, :deliver => true))
      SitesMailer.should_not_receive(:notify_error)

      SiteFetcher.perform(@site.id)
    end

    it "should not email when status is change from unknown to ok" do
      @site = FactoryGirl.create(:site)
      @response.stub(:success?).and_return(true) 
      SitesMailer.should_not_receive(:notify_resolved).and_return(stub(:mailer, :deliver => true))
      SitesMailer.should_not_receive(:notify_error)

      SiteFetcher.perform(@site.id)
    end

    it "should send when status is change from unknown to fail" do
      @site = FactoryGirl.create(:site)
      @response.stub(:success? => false, :timed_out? => false, :code => 404, :status_message => "Not found")
      SitesMailer.should_receive(:notify_error).and_return(stub(:mailer, :deliver => true))
      SitesMailer.should_not_receive(:notify_resolved)

      SiteFetcher.perform(@site.id)
    end
  end
  
  context "check rejected words and require words" do
    it "should send notification when a site do not contains required words" do
      @site = FactoryGirl.create(:ok_site)
      @site.content_validate_text = "Ruby"
      @site.content_validate_type = true
      @site.save

      @response.stub(:success?).and_return(true)
      @response.stub(:body).and_return("Java")
      SitesMailer.should_receive(:notify_error).and_return(stub(:mailer, :deliver => true))
      SitesMailer.should_not_receive(:notify_resolved)
      SiteFetcher.perform(@site.id)
    end
    
    it "should send notification when a site do contains rejected words" do
      @site = FactoryGirl.create(:ok_site)
      @site.content_validate_text = "Java"
      @site.content_validate_type = false
      @site.save

      @response.stub(:success?).and_return(true)
      @response.stub(:body).and_return("Java")
      SitesMailer.should_receive(:notify_error).and_return(stub(:mailer, :deliver => true))
      SitesMailer.should_not_receive(:notify_resolved)
      SiteFetcher.perform(@site.id)
    end
    
    it "should not send notification when a site contains required words" do
      @site = FactoryGirl.create(:ok_site)
      @site.content_validate_text = "Ruby"
      @site.content_validate_type = true
      @site.save

      @response.stub(:success?).and_return(true)
      @response.stub(:body).and_return("Ruby")
      SitesMailer.should_not_receive(:notify_error)
      SitesMailer.should_not_receive(:notify_resolved)
      SiteFetcher.perform(@site.id)
    end
    
    it "should not send notification when a site do not contains rejected words" do
      @site = FactoryGirl.create(:ok_site)
      @site.content_validate_text = "Java"
      @site.content_validate_type = false
      @site.save

      @response.stub(:success?).and_return(true)
      @response.stub(:body).and_return("Ruby")
      SitesMailer.should_not_receive(:notify_error)
      SitesMailer.should_not_receive(:notify_resolved)
      SiteFetcher.perform(@site.id)
    end
    
  end
end