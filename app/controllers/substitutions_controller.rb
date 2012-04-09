class SubstitutionsController < ApplicationController
  # GET /substitutions
  # GET /substitutions.json
  def index
    @substitutions = Substitution.all
    @not_my_subs = @substitutions.find_all{|s| !s.users.include?(@current_user)}
    @my_subs = @substitutions.find_all{|s| s.users.include?(@current_user)}
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @substitutions }
    end
  end

  # GET /substitutions/1
  # GET /substitutions/1.json
# this is pretty useless
#  def show
#    @substitution = Substitution.find(params[:id])
#    respond_to do |format|
#      format.html # show.html.erb
#      format.json { render json: @substitution }
#    end
#  end

  # GET /substitutions/new
  # GET /substitutions/new.json
  def new
    @entries = []
    @current_user.calendars.each do |c|
      c.entries.each do |e|
        @entries << e
      end
    end
    @entries = @entries.find_all{|e| e.substitution.nil?}
    @substitution = Substitution.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @substitution }
    end
  end

  # GET /substitutions/1/edit
  def edit
    @substitution = Substitution.find(params[:id])
  end

  # POST /substitutions
  # POST /substitutions.json
  def create
    entry_id = params[:substitution][:entry]
    params[:substitution][:entry] = Entry.find(params[:substitution][:entry])
    params[:substitution][:users] = [User.find(params[:substitution][:users])]
    @substitution = Substitution.new(params[:substitution])
    @entries = []
    @current_user.calendars.each do |c|
      c.entries.each do |e|
        @entries << e
      end
    end
    @entries = @entries.find_all{|e| e.substitution.nil?}

    respond_to do |format|
      if @substitution.save
        format.html { redirect_to new_substitution_path, notice: 'Substitution was successfully created.' }
        format.json { render json: @substitution, status: :created, location: @substitution }
      else
        format.html { render action: "new", notice: 'Substitution could not be created.' }
        format.json { render json: @substitution.errors, status: :unprocessable_entity }
    if entry_id.nil?
      flash[:notice] = 'Please select a shift to substitute'
      redirect_to new_substitution_path
    else
      params[:substitution][:entry] = Entry.find(params[:substitution][:entry])
      params[:substitution][:users] = [User.find(params[:substitution][:users])]
      @substitution = Substitution.new(params[:substitution])
      respond_to do |format|
        if @substitution.save
          format.html { redirect_to new_substitution_path, notice: 'Substitution was successfully created.' }
          format.json { render json: @substitution, status: :created, location: @substitution }
        else
          format.html { redirect_to new_substitution_path, notice: 'Substitution could not be created' }
          format.json { render json: @substitution.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # PUT /substitutions/1
  # PUT /substitutions/1.json
  def update
    @substitution = Substitution.find(params[:id])

    respond_to do |format|
      if @substitution.update_attributes(params[:substitution])
        format.html { redirect_to @substitution, notice: 'Substitution was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @substitution.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /substitutions/1
  # DELETE /substitutions/1.json
  def destroy
    @substitution = Substitution.find(params[:id])
    @substitution.destroy
    respond_to do |format|
      format.html { redirect_to substitutions_url }
      format.json { head :ok }
    end
  end
end
