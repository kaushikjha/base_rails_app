require File.dirname(__FILE__) + '/../spec_helper'

describe UsersController do
  integrate_views
  
  controller_should_require_login(:except => [:new, :create])
  
  describe 'index' do
    
    it 'should redirect you to the show page' do
      login
      get :index
      response.should redirect_to(my_account_url)
    end
    
  end
  
  describe 'new' do
    
    it 'should give you a new user page' do
      get :new
      user = assigns[:user]
      user.should be_new_record
      response.should render_template('new.html.erb')
      response.layout.should == 'layouts/application'
    end
    
  end
  
  describe 'create' do
    
    it 'should create a new user' do
      lambda {
        post :create, :user => {:login => 'bartsimpson', :email => 'bartsimpson@example.com',
                                :password => '123456', :password_confirmation => '123456'}
        response.should redirect_to(:action => 'show')
      }.should change(User, :count).by(1)
    end
    
  end
  
  describe 'show' do
    
    it 'should show you the current user' do
      login
      get :show, :id => current_user.id
      response.should render_template('show.html.erb')
      user = assigns[:current_user]
      user.should == current_user
    end
    
    it 'should not allow you to see another user' do
      login
      get :show, :id => current_user.id + 1
      response.should render_template('show.html.erb')
      user = assigns[:current_user]
      user.should == current_user
    end
    
  end
  
  describe 'edit' do
    
    it 'should give you an edit page' do
      login
      get :edit, :id => current_user.id
      response.should render_template('edit.html.erb')
      user = assigns[:current_user]
      user.should == current_user
    end
    
    it 'should only allow you to edit the current user' do
      login
      get :edit, :id => current_user.id + 1
      response.should render_template('edit.html.erb')
      user = assigns[:current_user]
      user.should == current_user
    end
    
  end
  
  describe 'update' do
    
    it 'should update the current user' do
      login
      post :update, :user => {:email => 'foobar@example.com'}
      response.should redirect_to(my_account_path)
      flash[:notice].should == 'Account updated!'
      current_user.reload
      current_user.email.should == 'foobar@example.com'
    end
    
  end
  
end
