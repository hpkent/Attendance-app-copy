class AutocompleteSerializer < ActiveModel::Serializer
  attributes :id, :label, :value

  def label
    "#{object.first_name} #{object.last_name}"
  end

  def value
    "#{object.first_name} #{object.last_name}"
  end

end
