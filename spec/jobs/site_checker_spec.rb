require 'spec_helper'

describe SiteChecker do
  before(:each) do
    @mailer = double(:sites_mailer).as_null_object
    @watcher = double(:watcher)
    SiteWatcher.stub(:new => @watcher)
    SitesMailer.stub(:new => @mailer)
  end

  context "fetch page and notify if needed" do
    it "should not send notification when status is ok and no change" do
      @site = FactoryGirl.create(:ok_site)
      @watcher.stub(:watch => "ok")
      @mailer.should_not_receive(:notify_error).should_not_receive(:notify_resolved)
      SiteChecker.perform(@site.id, @mailer)
    end
    
    it "should send when status is change from ok to fail" do
      @site = FactoryGirl.create(:ok_site)
      @watcher.stub(:watch => "failed")
    
      @mailer.should_receive(:notify_error).and_return(stub(:mailer, :deliver => true))
      @mailer.should_not_receive(:notify_resolved)
    
      SiteChecker.perform(@site.id, @mailer)
    end
    
    it "should send when status is change from fail to ok" do
      @site = FactoryGirl.create(:failed_site)
      @watcher.stub(:watch => "ok")

      @mailer.should_not_receive(:notify_error)
      @mailer.should_receive(:notify_resolved).and_return(stub(:mailer, :deliver => true))

      SiteChecker.perform(@site.id, @mailer)
    end

    it "should not email when status is change from unknown to ok" do
      @site = FactoryGirl.create(:site)
      @watcher.stub(:watch => "ok")
    
      @mailer.should_not_receive(:notify_error)
      @mailer.should_not_receive(:notify_resolved)
    
      SiteChecker.perform(@site.id, @mailer)
    end

    it "should send when status is change from unknown to fail" do
      @site = FactoryGirl.create(:site)
      @watcher.stub(:watch => "failed")

      @mailer.should_not_receive(:notify_resolved)
      @mailer.should_receive(:notify_error).and_return(stub(:mailer, :deliver => true))

      SiteChecker.perform(@site.id, @mailer)
    end 
  end
end