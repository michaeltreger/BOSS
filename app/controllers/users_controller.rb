require 'rubygems'
require 'net/ldap'

class UsersController < ApplicationController
  before_filter :check_admin, :only => ['new', 'destroy', 'edit', 'create', 'deactivate', 'activate']
  skip_before_filter :set_current_user, :only => 'initAdmin'
  skip_before_filter :set_period, :only => 'initAdmin'
  skip_before_filter :check_login, :only => 'initAdmin'
  skip_before_filter :check_admin_or_sched, :only => 'initAdmin'
  skip_before_filter CASClient::Frameworks::Rails::Filter, :only => 'initAdmin'
  skip_before_filter :check_init, :only => 'create'

  # GET /users
  # GET /users.json
  def index
    if params[:group]
      @users = Group.find(params[:group]).users.find_all {|u| u.activated?}
    else
      @users = User.find_all_by_activated(true)
    end
    @deactivatedUsers = User.find_all_by_activated(false)

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
    @acalendars = @user.calendars.find_all {|c| c.availability? and c.period.visible}
    @wcalendars = @user.calendars.find_all {|c| c.shift?}
    @preferences = @user.preference.find_all {|p| p.period.visible}
    @time_edits = TimeEdit.find_all_by_user_id(@user.id) || []
    @time_off_requests = TimeOffRequest.find_by_user_id(@user.id) || []
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


  ###TESTING FUNCTIONS###########

  def test_setuser
    if Rails.env.test?
      user_id = Integer(params[:id])
      @current_user = User.find_by_id(user_id)
      session[:test_user_id] = user_id
    end
    redirect_to '/'
  end

  ###############################

  # POST /users
  # POST /users.json
  def create
    @group = nil
    if params[:user][:user_type] != "-1" and not params[:user][:user_type].nil?
        @group = Group.find(params[:user][:user_type])
    end
    params[:user].delete :user_type
    @user = User.new(params[:user])
    if not @group.nil?
        @user.groups << @group
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
      if not params[:user][:user_type].nil?
        @group = nil
        @user.groups.delete Group.find_by_name("Administrators")
        @user.groups.delete Group.find_by_name("Schedulers")
        if params[:user][:user_type] != "-1"
            @group = Group.find(params[:user][:user_type])
        end
        params[:user].delete :user_type
        if not @group.nil?
            @user.groups << @group if not @user.groups.include? @group
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

  def removegroup
    @user = User.find(params[:user_id])
    @group = Group.find(params[:group_id])

    @user.groups.delete(@group)
    @group.users.delete(@user)

    @user.save!
    @group.save!

    redirect_to @user
  end

  def addagroup
    @user = User.find(params[:id])
    @groups = Group.all().delete_if { |group| @user.groups.include? group }

  end

  def initadmin
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @user }
    end
  end

  def deactivate
    @user = User.find(params[:id])

    @user.activated = false
    @user.initials = nil
    @user.save
    redirect_to users_path
  end

  def activateuser
    @user = User.find(params[:id])

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @user }
    end
  end
end
