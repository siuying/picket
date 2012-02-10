require 'spec_helper'

describe SiteFetcher do
  context "Fetcher Email Notifications" do
    before(:each) do
      @response = double(:response)
      SitesMailer = double(:sites_mailer).as_null_object
      SiteFetcher.stub(:get_url).and_return(@response)     
    end
    
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
end