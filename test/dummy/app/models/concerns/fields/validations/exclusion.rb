module Concerns::Fields
  module Validations::Exclusion
    extend ActiveSupport::Concern

    included do
      self.attribute_names << :exclusion
    end

    def exclusion
      @exclusion ||= ExclusionOptions.new(attributes[:exclusion])
    end

    def exclusion=(value)
      @exclusion = if value.is_a?(Hash) || value.respond_to?(&:to_h)
                     ExclusionOptions.new(val.to_h)
                   elsif value.is_a? ExclusionOptions
                     value
                   elsif value.nil?
                     ExclusionOptions.new
                   else
                     raise ArgumentError,
                           "`value` should be a #{Hash} or #{ExclusionOptions}, but got #{value.class}"
                   end
    end

    def interpret_to(model, field_name, accessibility, options = {})
      super
      exclusion.interpret_to model, field_name, accessibility, options
    end

    class ExclusionOptions < ::OptionsModel
      attribute_names.merge [:in, :message]

      def in
        attributes.fetch(:in) { [] }
      end

      def in=(value)
        attributes[:in] = if value.is_a?(Array) || value.respond_to?(:to_a)
                            value.to_a
                          elsif value.nil?
                            []
                          else
                            raise ArgumentError,
                                  "`value` should be #{Array} or could respond to `to_a`, but got #{value.class} -- #{value.inspect}"
                          end
      end

      def message
        attributes.fetch(:message) { "" }
      end

      def message=(value)
        attributes[:message] = ActiveModel::Type.lookup(:string).cast(value)
      end

      def interpret_to(model, field_name, _accessibility, _options = {})
        return if self.in.empty?

        options = {in: self.in}
        options[:message] = message if message.present?

        model.validates field_name, exclusion: options, allow_blank: true
      end
    end
  end
end
