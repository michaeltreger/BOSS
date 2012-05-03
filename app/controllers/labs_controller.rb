class LabsController < ApplicationController
  before_filter :check_admin, :only => ['new', 'destroy', 'edit', 'create']
  # GET /labs
  # GET /labs.json
  def index
    @labs = Lab.all.sort do |t1,t2|
        if t1.groups.length > 0 and t2.groups.length > 0
            (t1.groups[0].name <=> t2.groups[0].name)
        elsif t2.groups.length < 0
            1
        else
            -1
        end
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @labs }
    end
  end

  # GET /labs/1
  # GET /labs/1.json
  def show
    @lab = Lab.find(params[:id])
    @units = @lab.groups

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @lab }
    end
  end

  # GET /labs/new
  # GET /labs/new.json
  def new
    @lab = Lab.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @lab }
    end
  end

  # GET /labs/1/edit
  def edit
    @lab = Lab.find(params[:id])
  end

  # POST /labs
  # POST /labs.json
  def create
    @lab = Lab.new(params[:lab])
    respond_to do |format|
      if @lab.save
        format.html { redirect_to labs_path, notice: 'Lab was successfully created.' }
        format.json { render json: @lab, status: :created, location: @lab }
      else
        format.html { render action: "new" }
        format.json { render json: @lab.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /labs/1
  # PUT /labs/1.json
  def update
    @lab = Lab.find(params[:id])

    if not params[:lab][:groups].nil?
        @group = Group.find(params[:lab][:groups])
        params[:lab].delete :groups
        if @lab.groups.include?(@group)
            flash[:error] = "A group may not be added to the same lab multiple times."
            redirect_to @lab
            return
        else
            @lab.groups << @group
        end
      end


    respond_to do |format|
      if @lab.update_attributes(params[:lab])
        format.html { redirect_to labs_path, notice: 'Lab was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @lab.errors, status: :unprocessable_entity }
      end
    end

  end

  # DELETE /labs/1
  # DELETE /labs/1.json
  def destroy
    @lab = Lab.find(params[:id])
    @lab.destroy

    respond_to do |format|
      format.html { redirect_to labs_url }
      format.json { head :ok }
    end
  end

  def upload_shifts
    @lab = Lab.find(params[:id])

    respond_to do |format|
      format.html
      format.json { head :ok }
    end

  end

  def commit_shifts
    if @lab= Lab.find(params[:id])
      @lab.update_attributes(params[:file])
      filePath = @lab.text_file.path
      timeTable = @lab.read_schedule(filePath)

      startWeek = Time.new(Time.now.year, timeTable[0][2]["start_time_month"], timeTable[0][3]["start_time_day"], 8, 0, 0, "+01:00")
      endWeek =  Time.new(Time.now.year, timeTable[0][4]["end_time_month"], timeTable[0][5]["end_time_day"].to_i + 1, 8, 0, 0, "+01:00")

      respond_to do |format|
        if timeTable[0][0]["initials"] != @lab.initials
          flash.now[:error] = 'This flat file is not for this lab!'
          format.html { render action: "upload_shifts"}
        elsif Time.now > startWeek
          flash.now[:error] = 'Commiting shifts for past time!'
          format.html { render action: "upload_shifts"}
        elsif !@lab.is_week_empty?(startWeek, endWeek)
          flash.now[:error] = 'Selected week calendar not empty!'#Assuming never commit calendar for the same week, use sub or time_edit to do changes.
          format.html { render action: "upload_shifts"}
        else
          noInit = false
          if timeTable[0][6] != {}
            xx = true
          end
          for i in 1..24
            for j in 0..6
              if timeTable[i][j] != {}
                timeTable[i][j].each do |k, v|
                  if k !='xx' and k != 'XX' and !(employee = User.find_by_initials(k))
                    noInit = true
                    flash[:error] = "Employee with initials: #{k} does not exist!"
                    format.html { render action: "upload_shifts"}
                  end
                end
              end
            end
          end
          if !noInit
            for i in 1..24
              for j in 0..6
                if timeTable[i][j] != {}
                  timeOffset = (j * 24 + i + 7).hour
                  startTime = startWeek + timeOffset

                  timeTable[i][j].each do |k, v|
                    endTime = startTime + 1.hour

                    if  k !='XX' and k != 'xx'
                      t=i+1
                      while timeTable[t][j].include?(k)
                        if timeTable[t][j][k] == 0
                          endTime += 1.hour
                        elsif timeTable[t][j][k] == 1
                          endTime += 30.minute
                        end
                        timeTable[t][j].delete(k)
                        t+=1
                      end
                    end

                    if k =='XX' or k == 'xx'
                      #sub must have entry attributes. entry must have start&end time. Associate all xx shifts with Chris
                      xxEntry = Entry.create!(:entry_type => 'xx', :user_id => 7, :start_time => startTime, :end_time => endTime, :lab_id => @lab.id, :description => "")
                      Substitution.create!(:entry => xxEntry, :entry_id => xxEntry.id, :description => 'This is an xx shifts.')
                    else
                      if v == 0
                        employee = User.find_by_initials(k)
                        employee.shift_calendar.entries << Entry.create!(:entry_type => 'shift', :user_id => employee.id, :start_time => startTime, :end_time => endTime, :description => "#{employee.name}@#{@lab.name}", :lab_id => @lab.id)
                      elsif v == 1
                        endTime = startTime + 30.minute
                        employee.shift_calendar.entries << Entry.create!(:entry_type => 'shift', :user_id => employee.id, :start_time => startTime, :end_time => endTime, :description => "#{employee.name}@#{@lab.name}", :lab_id => @lab.id)
                      elsif v == 2
                        startTime = startTime + 30.minute
                        employee.shift_calendar.entries << Entry.create!(:entry_type => 'shift', :user_id => employee.id, :start_time => startTime, :end_time => endTime, :description => "#{employee.name}@#{@lab.name}", :lab_id => @lab.id)
                      end
                    end
                  end
                end
              end
            end
          end
        end

        format.html { redirect_to labs_path, notice: 'Shifts were successfully assigned.' }
        format.json { head :ok }
      end
    end
  end

  def addaunit
    @lab = Lab.find(params[:id])
    @units = Unit.all().delete_if { |unit| @lab.groups.include? unit }

  end

  def removeunit
    @lab = Lab.find(params[:lab_id])
    @unit = Unit.find(params[:unit_id])

    @lab.groups.delete(@unit)
    @unit.labs.delete(@lab)

    @lab.save!
    @unit.save!

    redirect_to @lab
  end

end
