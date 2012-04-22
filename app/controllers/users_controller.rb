require 'rubygems'
require 'net/ldap'

class UsersController < ApplicationController

  # GET /users
  # GET /users.json
  def index
    @users = User.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @users }
    end
  end

  # GET /users/1
  # GET /users/1.json
  def show
    #flash[:notice] = "You are logged in as #{ldapparams[0][:givenname][0]} #{ldapparams[0][:sn][0]}."
    @user = User.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/new
  # GET /users/new.json
  def new
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
  end


  ###DEBUGGING FUNCTIONS###########
  def changeAdmin
    @current_user.user_type = Integer(params[:user_type])
    @current_user.save!
    redirect_to '/'
  end

  def test_setuser
    if Rails.env.test?
      user_id = Integer(params[:id])
      @current_user = User.find_by_id(user_id)
      session[:test_user_id] = user_id
    end
    redirect_to '/'
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(params[:user])
    @user.cas_user = session[:cas_user]
    @user.name = ldapparams[0][:givenname][0] + " " + ldapparams[0][:sn][0]
    @user.email = ldapparams[0][:mail][0]
    @user.approved = false

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render json: @user, status: :created, location: @user }
      else
        format.html { render action: "new" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.json
  def update
    @user = User.find(params[:id])
    if not @user.approved?
      @user.approved = true
      @user.calendars << Calendar.create!(:calendar_type => 0, :name => "#{@user.name}'s Calendar")
    end

    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to users_url }
      format.json { head :ok }
    end
  end

  def logout
    CASClient::Frameworks::Rails::Filter.logout(self)
  end

end
