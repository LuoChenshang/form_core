module Concerns::Fields
  module Validations::Inclusion
    extend ActiveSupport::Concern

    included do
      self.attribute_names << :inclusion
    end

    def inclusion
      @inclusion ||= InclusionOptions.new(attributes[:inclusion])
    end

    def inclusion=(value)
      @inclusion = if value.is_a?(Hash) || value.respond_to?(&:to_h)
                     InclusionOptions.new(value.to_h)
                   elsif value.is_a? InclusionOptions
                     value
                   elsif value.nil?
                     InclusionOptions.new
                   else
                     raise ArgumentError,
                           "`value` should be a #{Hash} or #{InclusionOptions}, but got #{value.class}"
                   end
    end

    def interpret_to(model, field_name, accessibility, options = {})
      super
      inclusion.interpret_to model, field_name, accessibility, options
    end

    class InclusionOptions < ::OptionsModel
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

        model.validates field_name, inclusion: options, allow_blank: true
      end
    end
  end
end
