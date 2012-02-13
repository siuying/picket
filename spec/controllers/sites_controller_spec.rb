require 'spec_helper'

describe SitesController do
  context "User not logged in" do
    let(:site) { Factory(:site) }

    describe "GET index" do
      it "should be redirected to login page" do
        get :index
        response.should redirect_to(new_user_session_path)
      end
    end
    
    describe "GET show" do
      it "should be redirected to login page" do
        get :show, :id => site.id
        response.should redirect_to(new_user_session_path)
      end
    end
    
    describe "GET new" do
      it "should be redirected to login page" do
        get :new
        response.should redirect_to(new_user_session_path)
      end
    end
    
    describe "GET edit" do
      it "should be redirected to login page" do
        get :edit, :id => site.id
        response.should redirect_to(new_user_session_path)
      end
    end
    
    describe "POST create" do
      it "should be redirected to login page" do
        url = "http://abc.def.com"
        post :create, :site => {:url => url}
        response.should redirect_to(new_user_session_path)
      end
    end
    
    describe "PUT update" do
      it "should be redirected to login page" do
        url = "http://abc.def.com"
        put :update, :id => site.id, :site => {:url => url, :id => site.id}
        response.should redirect_to(new_user_session_path)
      end
    end
    
    describe "DELETE destroy" do
      it "should be redirected to login page" do
        delete :destroy, :id => site.id
        response.should redirect_to(new_user_session_path)
      end
    end
  end
  
  context "User logged in" do
    let(:bob) { Factory(:bob) }
    before(:each) { 
      @site = Factory.create(:site, :user => bob)
      sign_in bob 
    }
    
    describe "GET index" do
      it "should see their sites" do

        get :index
        response.should render_template("index")
        assigns(:sites).should == [@site]
      end
    end
    
    describe "GET show" do
      it "should see their site details" do
        get :show, :id => @site.id
        response.should render_template("show")
        assigns(:site).should == @site
      end
    end
    
    describe "GET new" do
      it "should show a new site form" do
        get :new
        response.should render_template("new")
      end
    end
    
    describe "GET edit" do
      it "should show a edit site form" do
        get :edit, :id => @site.id
        response.should render_template("edit")
        assigns(:site).should == @site
      end
    end
    
    describe "POST create" do
      it "should create a site" do
        url = "http://abc.def.com"
        post :create, :site => {:url => url}
        site = Site.where(:url => url).first
        site.should_not be_nil
        response.should redirect_to(site_path(site))
      end
    end
    
    describe "PUT update" do
      it "should update use site" do
        url = "http://abc.def.com"
        put :update, :id => @site.id, :site => {:url => url, :id => @site.id}
        response.should redirect_to(site_path(@site))
        site = Site.find(@site.id)
        site.should_not be_nil
        site.url.should == url
      end
    end
    
    describe "DELETE destroy" do
      it "should delete user site" do
        delete :destroy, :id => @site.id
        response.should redirect_to(sites_url)
        lambda { Site.find(@site.id) }.should raise_error(Mongoid::Errors::DocumentNotFound)
      end
    end    
  end
end