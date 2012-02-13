require 'spec_helper'

describe SitesMailer do
  it "#notify_error" do
    site = Factory(:site)
    email = SitesMailer.notify_error(site.id).deliver
    site.user.email.should == email.to.first
    email.subject.should =~ /detected/
    email.subject.should =~ /#{site.url}/
  end
  
  it "#notify_resolved" do
    site = Factory(:ok_site)
    email = SitesMailer.notify_resolved(site.id).deliver
    site.user.email.should == email.to.first
    email.subject.should =~ /resolved/
    email.subject.should =~ /#{site.url}/
  end
end