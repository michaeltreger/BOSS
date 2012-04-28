class Group < ActiveRecord::Base
    has_many :group_users
    has_many :users, :through => :group_users
    has_many :group_labs
    has_many :labs, :through => :group_labs
end
