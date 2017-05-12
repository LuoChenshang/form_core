module Concerns::Fields
  module Validations::Format
    extend ActiveSupport::Concern

    included do
      self.attribute_names << :format
    end

    def format
      @format ||= FormatOptions.new(attributes[:format])
    end

    def format=(value)
      @format = if value.is_a?(Hash) || value.respond_to?(&:to_h)
                  FormatOptions.new(value.to_h)
                elsif value.is_a? FormatOptions
                  value
                elsif value.nil?
                  FormatOptions.new
                else
                  raise ArgumentError,
                        "`value` should be a #{Hash} or #{FormatOptions}, but got #{value.class}"
                end
    end

    def interpret_to(model, field_name, accessibility, options = {})
      super
      format.interpret_to model, field_name, accessibility, options
    end

    class FormatOptions < ::OptionsModel
      attribute_names.merge [:with, :message]

      def with
        attributes.fetch(:with) { "" }
      end

      def with=(value)
        attributes[:with] = ActiveModel::Type.lookup(:string).cast(value)
      end

      def message
        attributes.fetch(:message) { "" }
      end

      def message=(value)
        attributes[:message] = ActiveModel::Type.lookup(:string).cast(value)
      end

      validate do
        begin
          Regexp.new(with) if with.present?
        rescue RegexpError
          errors.add :with, :invalid
        end
      end

      def interpret_to(model, field_name, _accessibility, _options = {})
        return if with.blank?

        with = Regexp.new(self.with)

        options = {with: with}
        options[:message] = message if message.present?

        model.validates field_name, format: options, allow_blank: true
      end
    end
  end
end
