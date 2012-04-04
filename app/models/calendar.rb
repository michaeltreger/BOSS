class Calendar < ActiveRecord::Base
    belongs_to :lab
    has_many :entries
    belongs_to :user
    validates_presence_of :type, :name
end
