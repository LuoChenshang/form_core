class OptionsModel
  include ActiveModel::Model
  include Concerns::OptionsModel::Serialization
  include Concerns::OptionsModel::Attribute
  include EnumTranslate

  def inspect
    "#<#{self.class} #{self.to_h}>"
  end

  def self.inspect
    "#<#{self} [#{attribute_names.map(&:inspect).join(', ')}]>"
  end

  def interpret_to(_model, _field_name, _accessibility, _options = {})

  end
end
