require 'spec_helper'

describe UserController do
  let(:alice) { Factory(:alice) }
  let(:bob) { Factory(:bob) }

  context "User not logged in" do
    describe "GET index" do
      it "should be redirected to login page" do
        get :index
        response.should redirect_to(new_user_session_path)
      end
    end
  end
  
  context "User logged in" do
    before(:each) { sign_in bob }

    describe "GET index" do
      it "should open user profile page" do
        get :index
        response.should render_template("index")
        assigns(:user).should == bob 
      end
    end

    describe "POST update" do
      it "should update user profile" do
        user_id = bob.id
        email = "a@example.com"

        post :update, :user => {:email => email, :password => "", :password_confirmation => ""}
        response.should redirect_to(profile_path)
        User.find(user_id).email.should == email
      end
      
      it "should only update user profile of themself" do
        user_id = bob.id
        email = "a@example.com"
        another_user_id = alice.id

        post :update, :user => {:id => another_user_id, :email => email, :password => "", :password_confirmation => ""}
        response.should redirect_to(profile_path)
        User.find(user_id).email.should == email
        User.find(another_user_id).email.should_not == email        
      end
    end
  end
end