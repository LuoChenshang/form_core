module Fields::Options
  class DecimalField < ::OptionsModel
    def step
      attributes.fetch(:step) { 0 }
    end

    def step=(val)
      attributes[:step] = ActiveModel::Type.lookup(:decimal).cast(val)
    end

    validates :step,
              numericality: {
                greater_than_or_equal_to: 0.0
              }

    self.attribute_names << :step
  end
end
