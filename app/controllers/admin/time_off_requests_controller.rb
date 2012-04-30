include TimeOffRequestsHelper

class Admin::TimeOffRequestsController < ApplicationController
  # GET admin/time_off_requests
  # GET admin/time_off_requests.json
  def index
    if !Rails.env.test?
      recycle
    end
    @time_off_requests = TimeOffRequest.all
  end
 
  # GET admin/time_off_requests/1
  # GET admin/time_off_requests/1.json
  #useless
  def show
    @time_off_request = TimeOffRequest.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @time_off_request }
    end
  end

  # GET admin/time_off_requests/new
  # GET admin/time_off_requests/new.json
  def new
    @time_off_request = TimeOffRequest.new
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @time_off_request }
    end
  end

  # GET admin/time_off_requests/1/edit
  def edit
    @time_off_request = TimeOffRequest.find(params[:id])
  end

  # PUT admin/time_off_requests/1
  # PUT admin/time_off_requests/1.json
  def update
    @time_off_request = TimeOffRequest.find(params[:id])
    respond_to do |format|
      if @time_off_request.update_attributes(params[:time_off_request])
          format.html { redirect_to admin_time_off_requests_url, notice: 'Time off request was successfully updated.' }
          format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @time_off_request.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE admin/time_off_requests/1
  # DELETE admin/time_off_requests/1.json
  def destroy
    @time_off_request = TimeOffRequest.find(params[:id])
    @time_off_request.destroy
    
    respond_to do |format|
      format.html { redirect_to admin_time_off_requests_url}
      format.json { head :ok }
    end
  end
end
