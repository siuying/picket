require 'spec_helper'

describe SiteWatcher do
  before(:each) do
    @response = double(:response)
    @response.stub(:body => "anything")
  end

  let(:site) { FactoryGirl.create(:ok_site) }
  let(:watcher) { SiteWatcher.new(site) }
  
  context "Watch real site responses" do    
    it "should be ok watching ignition.hk site" do
      VCR.use_cassette('ignition.hk') do
        watcher.watch
        site.state.should == "ok"
        site.message.should == ""
      end
    end
  end

  context "Watch a site response and update state as needed" do
    before(:each) do
      watcher.stub(:get_url).and_return(@response)
    end

    it "should be ok when response success" do
      @response.stub(:success? => true)
      watcher.watch

      site.state.should == "ok"
      site.message.should == ""
    end
    
    it "should be failed when response timed out" do
      @response.stub(:success? => false, :timed_out? => true)
      watcher.watch

      site.state.should == "failed"
      site.message.should =~ /timing out/
    end

    it "should be failed when no http response code" do
      @response.stub(:success? => false, :timed_out? => false, :code => 0)
      watcher.watch

      site.state.should == "failed"
      site.message.should =~ /Could not get an http response/
    end
    
    it "should be failed when return unexpected http response code" do
      @response.stub(:success? => false, :timed_out? => false, :code => 503, :status_message => "Server Error")
      watcher.watch

      site.state.should == "failed"
      site.message.should =~ /Server Error/
    end
    
    it "should success when site contains required words" do
      site.content_validate_type = true
      site.content_validate_text = "Ruby"
      @response.stub(:success? => true, :body => "Programming Ruby")
      watcher.watch

      site.state.should == "ok"
      site.message.should == ""
    end
    
    it "should failed when site doesnt contains required words" do
      site.content_validate_type = true
      site.content_validate_text = "Ruby"
      @response.stub(:success? => true, :body => "Programming Java")
      watcher.watch

      site.state.should == "failed"
      site.message.should =~ /Validation fail: Contains "Ruby"/
    end

    it "should success when site doesnt contains rejected words" do
      site.content_validate_type = false
      site.content_validate_text = "Basic"
      @response.stub(:success? => true, :body => "Programming Ruby")
      watcher.watch

      site.state.should == "ok"
      site.message.should == ""
    end
    
    it "should failed when site contains reject words" do
      site.content_validate_type = false
      site.content_validate_text = "Basic"
      @response.stub(:success? => true, :body => "Programming Basic")
      watcher.watch

      site.state.should == "failed"
      site.message.should =~ /Validation fail: Doesn't contains "Basic"/
    end
  end
end