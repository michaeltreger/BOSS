require 'rubygems'
require 'net/ldap'

class UsersController < ApplicationController

  skip_before_filter :set_current_user, :only => 'initAdmin'
  skip_before_filter :set_period, :only => 'initAdmin'
  skip_before_filter :check_login, :only => 'initAdmin'
  skip_before_filter :check_admin, :only => 'initAdmin'
  skip_before_filter CASClient::Frameworks::Rails::Filter, :only => 'initAdmin'
  skip_before_filter :check_init, :only => 'create'


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
    @groups = @user.groups

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
    Period.find_all_by_visible(true).each do |p|
      avail_calendar = Calendar.create!(:name=> "#{@user.name}'s #{p.name} Availabilities", 
                                        :calendar_type=>Calendar::AVAILABILITY)
      shift_calendar = Calendar.create!(:name=> "#{@user.name}'s #{p.name} Shifts", 
                                        :calendar_type=>Calendar::SHIFTS)

      pref = Preference.create!()

      @user.calendars << avail_calendar
      @user.calendars << shift_calendar
      @user.preference << pref

      p.calendars << avail_calendar
      p.calendars << shift_calendar
      p.preferences << pref
      p.save!
    end

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

    respond_to do |format|
      if not params[:user][:groups].nil?
        @group = Group.find(params[:user][:groups])
        params[:user].delete :groups
        if @user.groups.include?(@group)
            flash[:error] = "A user may not be added to the same group multiple times."
            redirect_to @user
            return
        else
            @user.groups << @group
        end
      end
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

  def removeGroup
    @user = User.find(params[:user_id])
    @group = Group.find(params[:group_id])
    
    @user.groups.delete(@group)
    @group.users.delete(@user)

    @user.save!
    @group.save!

    redirect_to @user
  end
  
  def addGroup
    @user = User.find(params[:id])
    @groups = Group.all()

  end

  def initAdmin
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @user }
    end
  end
end
