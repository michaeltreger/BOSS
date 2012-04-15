class TimeEditsController < ApplicationController
  # GET /time_edits
  # GET /time_edits.json
  def index
    @time_edits = TimeEdit.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @time_edits }
    end
  end

  # GET /time_edits/1
  # GET /time_edits/1.json
  def show
    @time_edit = TimeEdit.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @time_edit }
    end
  end

  # GET /time_edits/new
  # GET /time_edits/new.json
  def new
    @time_edit = TimeEdit.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @time_edit }
    end
  end

  # GET /time_edits/1/edit
  def edit
    @time_edit = TimeEdit.find(params[:id])
  end

  # POST /time_edits
  # POST /time_edits.json
  def create
    @time_edit = TimeEdit.new(params[:time_edit])

    respond_to do |format|
      if @time_edit.save
        format.html { redirect_to @time_edit, notice: 'Time edit was successfully created.' }
        format.json { render json: @time_edit, status: :created, location: @time_edit }
      else
        format.html { render action: "new" }
        format.json { render json: @time_edit.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /time_edits/1
  # PUT /time_edits/1.json
  def update
    @time_edit = TimeEdit.find(params[:id])

    respond_to do |format|
      if @time_edit.update_attributes(params[:time_edit])
        format.html { redirect_to @time_edit, notice: 'Time edit was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @time_edit.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /time_edits/1
  # DELETE /time_edits/1.json
  def destroy
    @time_edit = TimeEdit.find(params[:id])
    @time_edit.destroy

    respond_to do |format|
      format.html { redirect_to time_edits_url }
      format.json { head :ok }
    end
  end
end
