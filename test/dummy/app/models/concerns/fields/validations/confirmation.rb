module Concerns::Fields
  module Validations::Confirmation
    extend ActiveSupport::Concern

    included do
      self.attribute_names << :confirmation
    end

    def confirmation
      attributes.fetch(:confirmation) { false }
    end
    alias_method :confirmation?, :confirmation

    def confirmation=(value)
      attributes[:confirmation] = ActiveModel::Type.lookup(:boolean).cast(value)
    end

    def interpret_to(model, field_name, _accessibility, _options = {})
      super
      return unless confirmation?

      model.validates field_name, confirmation: true
    end
  end
end
