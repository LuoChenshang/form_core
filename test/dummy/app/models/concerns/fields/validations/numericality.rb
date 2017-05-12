module Concerns::Fields
  module Validations::Numericality
    extend ActiveSupport::Concern

    included do
      attribute_names << :numericality
    end

    def numericality
      @numericality ||= NumericalityOptions.new(attributes[:numericality])
    end

    def numericality=(value)
      @numericality = if value.is_a?(Hash) || value.respond_to?(&:to_h)
                        NumericalityOptions.new(value.to_h)
                      elsif value.is_a? NumericalityOptions
                        value
                      elsif value.nil?
                        NumericalityOptions.new
                      else
                        raise ArgumentError,
                              "`val` should be a #{Hash} or #{NumericalityOptions}, but got #{value.class}"
                      end
    end

    def interpret_to(model, field_name, accessibility, options = {})
      super
      numericality.interpret_to model, field_name, accessibility, options
    end

    class NumericalityOptions < ::OptionsModel
      attribute_names.merge [:lower_value, :lower_bound, :upper_value, :upper_bound]

      def lower_value
        attributes.fetch(:lower_value) { 0 }
      end

      def lower_value=(val)
        attributes[:lower_value] = ActiveModel::Type.lookup(:float).cast(val)
      end

      def upper_value
        attributes.fetch(:upper_value) { 0 }
      end

      def upper_value=(val)
        attributes[:upper_value] = ActiveModel::Type.lookup(:float).cast(val)
      end

      @lower_bounds = %w(disabled greater_than greater_than_or_equal_to).freeze
      def self.lower_bounds
        @lower_bounds
      end

      def lower_bound
        attributes.fetch(:lower_bound) { "disabled" }.to_sym
      end

      def lower_bound=(value)
        attributes[:lower_bound] = ActiveModel::Type.lookup(:string).cast(value)
      end

      @upper_bounds = %w(disabled less_than less_than_or_equal_to).freeze
      def self.upper_bounds
        @upper_bounds
      end

      def upper_bound
        attributes.fetch(:upper_bound) { "disabled" }.to_sym
      end

      def upper_bound=(value)
        attributes[:upper_bound] = ActiveModel::Type.lookup(:string).cast(value)
      end

      validates :lower_bound, inclusion: {in: lower_bounds.map(&:to_sym)}
      validates :upper_bound, inclusion: {in: upper_bounds.map(&:to_sym)}

      validates :upper_value,
                numericality: {
                  greater_than: :lower_value
                },
                if: proc { upper_bound != :disabled && lower_bound != :disabled }

      def interpret_to(model, field_name, _accessibility, _options = {})
        options = {}
        options[lower_bound] = lower_value unless lower_bound == :disabled
        options[upper_bound] = upper_value unless upper_bound == :disabled
        return if options.empty?

        model.validates field_name, numericality: options, allow_blank: true
      end
    end
  end
end
