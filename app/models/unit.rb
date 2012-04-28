class Unit < Group
    def Unit.all
        Group.find_all_by_unit(true)
    end
end
