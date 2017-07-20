class Monastic < ActiveRecord::Base
  has_many :meetings
    def monastic_name
      "#{self.title} #{self.first_name} #{self.last_name}" 
    end
end
