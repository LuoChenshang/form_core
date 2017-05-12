module Concerns::Fields
  module Validations::Acceptance
    extend ActiveSupport::Concern

    included do
      self.attribute_names << :acceptance
    end

    def acceptance
      attributes.fetch(:acceptance) { false }
    end
    alias_method :acceptance?, :acceptance

    def acceptance=(value)
      attributes[:acceptance] = ActiveModel::Type.lookup(:boolean).cast(value)
    end

    def interpret_to(model, field_name, _accessibility, _options = {})
      super
      return unless acceptance?

      model.validates field_name, acceptance: true
    end
  end
end
