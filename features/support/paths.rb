# TL;DR: YOU SHOULD DELETE THIS FILE
#
# This file is used by web_steps.rb, which you should also delete
#
# You have been warned
module NavigationHelpers
  # Maps a name to a path. Used by the
  #
  #   When /^I go to (.+)$/ do |page_name|
  #
  # step definition in web_steps.rb
  #
  def path_to(page_name)
    case page_name

    when /^the home\s?page$/
      '/'
    when /^the "Post a Substitution" page$/
      '/substitutions/new'
    when /^the "View Substitutions" page$/
      '/substitutions'
    when /^the "Manage Substitutions" page$/
      '/admin/substitutions'
    when /^(.*)'s Availability Calendar for "(.*)"$/
      owner = User.find_by_name($1)
      period = Period.find_by_name($2)
      calendar_id = (owner.availability_calendar(period)).id
      '/calendars/'+calendar_id.to_s
    when /^(.*'s) Calendar page$/
      calendar_id = (Calendar.find_by_name($1+" Calendar")).id
      '/calendars/'+calendar_id.to_s
    when /^(.*)'s Shifts page$/
      calendar_id = (User.find_by_name($1).shift_calendar).id
      '/calendars/'+calendar_id.to_s
    when /^the "(.*)" Lab Shifts page$/
      lab = Lab.find_by_name($1)
      calendar_id = lab.calendar.id
      '/calendars/'+calendar_id.to_s
    when /^the "Time Edit" page$/
      '/time_edits'
    when /^the "New Time Edit" page$/
      '/time_edits/new'
    when /^my time-off requests page$/
      '/time_off_requests'
    when /^all time-off requests page$/
      '/admin/time_off_requests'
    when /^New Request$/
      '/time_off_requests/new'
    when /^the Create New Request page$/
      '/time_off_requests/new'
    when /^the "Admin Labs" page$/
      '/admin/labs'
    when /^the "Admin Groups" page$/
      '/admin/groups'
    when /^(.*)'s upload file page$/
      '/admin/upload_shifts/'+ Lab.find_by_name($1).id.to_s
    # Add more mappings here.
    # Here is an example that pulls values out of the Regexp:
    #
    #   when /^(.*)'s profile page$/i
    #     user_profile_path(User.find_by_login($1))

    when /^the "Users" page$/
        '/admin/users/'
    when /^the "Groups" page$/
        '/admin/groups/'
    when /^the BOS homepage$/
        '/'
    when /^the "View Labs" page$/
        '/admin/labs'

    else
      begin
        page_name =~ /^the (.*) page$/
        path_components = $1.split(/\s+/)
        self.send(path_components.push('path').join('_').to_sym)
      rescue NoMethodError, ArgumentError
        raise "Can't find mapping from \"#{page_name}\" to a path.\n" +
          "Now, go and add a mapping in #{__FILE__}"
      end
    end
  end
end

World(NavigationHelpers)
