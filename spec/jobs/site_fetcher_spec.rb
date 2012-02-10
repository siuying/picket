describe SiteFetcher do
  context "Fetcher should send email" do
    before(:each) do
      @site = Site.create!(:url => "http://google.com", 
        :status => Site::STATUS_OK,
        :status_changed_at => 3.minutes.ago)
      @response = double(:response)
      SitesMailer = double(:sites_mailer).as_null_object
      SiteFetcher.stub(:get_url).and_return(@response)     
    end
    
    it "should not send email when status is ok and no change" do
      @response.stub(:success?).and_return(true)
      SitesMailer.should_not_receive(:notify_error).should_not_receive(:notify_resolved)

      SiteFetcher.perform(@site.id)
    end

    it "should send email when status is change from ok to fail" do
      @site.update_attribute :status, Site::STATUS_OK
      @response.stub(:success? => false, :timed_out? => false, :code => 404, :status_message => "Not found")
      SitesMailer.should_receive(:notify_error).and_return(stub(:mailer, :deliver => true))
      SitesMailer.should_not_receive(:notify_resolved)

      SiteFetcher.perform(@site.id)
    end
    
    it "should send email when status is change from fail to ok" do
      @site.update_attribute :status, Site::STATUS_FAILED
      @response.stub(:success?).and_return(true) 
      SitesMailer.should_receive(:notify_resolved).and_return(stub(:mailer, :deliver => true))
      SitesMailer.should_not_receive(:notify_error)

      SiteFetcher.perform(@site.id)
    end
    
    
  end
end