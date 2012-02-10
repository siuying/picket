require 'spec_helper'

describe Site do
  context "Site has status" do
    it "should not ok nor fail when created" do
      site = Site.create
    end
  end
end