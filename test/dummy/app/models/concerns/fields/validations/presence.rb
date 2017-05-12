module Concerns::Fields
  module Validations::Presence
    extend ActiveSupport::Concern

    included do
      self.attribute_names << :presence
    end

    def presence
      attributes.fetch(:presence) { false }
    end
    alias_method :presence?, :presence

    def presence=(val)
      attributes[:presence] = ActiveModel::Type.lookup(:boolean).cast(val)
    end

    def interpret_to(model, field_name, _accessibility, _options = {})
      super
      return unless presence?

      model.validates field_name, presence: true
    end
  end
end
