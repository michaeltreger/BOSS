module TimeOffRequestsHelper

def recycle
    TimeOffRequest.all.each do |request|
      if request.start_time < Time.current
        request.destroy
      end
    end
  end

end
