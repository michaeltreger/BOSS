

class TimeOffRequestsController < ApplicationController
  # GET /time_off_requests
  # GET /time_off_requests.json
  def index
    recycle
    if @current_user.isAdmin?
      @time_off_requests = TimeOffRequest.all
    else
      @time_off_requests = TimeOffRequest.find_all_by_user_id(@current_user.id)
    end
    
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @time_off_requests }
    end
  end

  def recycle
    TimeOffRequest.all.each do |request|
      if request.start_time < Time.current
        request.destroy
      end
    end
  end

 
  # GET /time_off_requests/1
  # GET /time_off_requests/1.json
  #useless
  def show
    @time_off_request = TimeOffRequest.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @time_off_request }
    end
  end

  # GET /time_off_requests/new
  # GET /time_off_requests/new.json
  def new
    @time_off_request = TimeOffRequest.new
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @time_off_request }
    end
  end

  # GET /time_off_requests/1/edit
  def edit
    @time_off_request = TimeOffRequest.find(params[:id])
  end

  # POST /time_off_requests
  # POST /time_off_requests.json
  def create
    @time_off_request = TimeOffRequest.new(params[:time_off_request])
    @time_off_request.user_id = @current_user.id

    respond_to do |format|
      if @time_off_request.isNotTimeValid?
        flash.now[:error] = "Invalid end time"
        format.html { render action: "new" }
        format.json { render json: @time_off_request.errors, status: :unprocessable_entity }
      else
        @time_off_request.day_notice = @time_off_request.distance_of_time
        if @time_off_request.save
          format.html { redirect_to time_off_requests_url, notice: 'Time off request was successfully created.' }
          format.json { render json: @time_off_request, status: :created, location: @time_off_request }
        else
          format.html { render action: "new" }
          format.json { render json: @time_off_request.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # PUT /time_off_requests/1
  # PUT /time_off_requests/1.json
  def update
    @time_off_request = TimeOffRequest.find(params[:id])
    respond_to do |format|
      if @time_off_request.update_attributes(params[:time_off_request])
        format.html { redirect_to time_off_requests_url, notice: 'Time off request was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @time_off_request.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /time_off_requests/1
  # DELETE /time_off_requests/1.json
  def destroy
    @time_off_request = TimeOffRequest.find(params[:id])
    @time_off_request.destroy

    respond_to do |format|
      format.html { redirect_to time_off_requests_url }
      format.json { head :ok }
    end
  end
end
