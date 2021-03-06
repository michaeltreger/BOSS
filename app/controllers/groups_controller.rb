class GroupsController < ApplicationController
  before_filter :check_admin, :only => ['new', 'update', 'addusers', 'destroy', 'edit', 'create']
  # GET /groups
  # GET /groups.json
  def index
    if @current_user.isAdmin?
        @groups = Group.all
    else
        @groups = @current_user.groups
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @groups }
    end
  end

  # GET /groups/1
  # GET /groups/1.json
  def show
    @group = Group.find(params[:id])
    @users = @group.users.delete_if { |user| not user.activated }

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @group }
    end
  end

  # GET /groups/new
  # GET /groups/new.json
  def new
    @group = Group.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @group }
    end
  end

  # GET /groups/1/edit
  def edit
    @group = Group.find(params[:id])
  end

  # POST /groups
  # POST /groups.json
  def create
    @group = Group.new(params[:group])

    respond_to do |format|
      if @group.save
        format.html { redirect_to @group, notice: 'Group was successfully created.' }
        format.json { render json: @group, status: :created, location: @group }
      else
        format.html { render action: "new" }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /groups/1
  # PUT /groups/1.json
  def update
    @group = Group.find(params[:id])

    respond_to do |format|
      if not params[:group][:users].nil?
        @user = User.find(params[:group][:users])
        params[:group].delete :users
        if @group.users.include?(@user)
            flash[:error] = "A user may not be added to the same group multiple times."
            redirect_to @group
            return
        else
            @group.users << @user
        end
      end
      if @group.update_attributes(params[:group])
        format.html { redirect_to @group, notice: 'Group was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /groups/1
  # DELETE /groups/1.json
  def destroy
    @group = Group.find(params[:id])
    @group.destroy

    respond_to do |format|
      format.html { redirect_to groups_url }
      format.json { head :ok }
    end
  end

  def addusers
    @group = Group.find(params[:id])
    @users = User.find_all_by_activated(true).delete_if { |user| @group.users.include? user }
  end
end
