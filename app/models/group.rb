class Group < ActiveRecord::Base
    has_many :users

    #This should help with abstraction so we can use group.members
    #instead of group.users which is ambiguious.
    def members
        @users
    end
    
end
