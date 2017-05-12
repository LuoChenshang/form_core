module Concerns::Fields
  module Validations::Length
    extend ActiveSupport::Concern

    included do
      self.attribute_names << :length
    end

    def length
      @length ||= LengthOptions.new(attributes[:length])
    end

    def length=(value)
      @length = if value.is_a?(Hash) || value.respond_to?(&:to_h)
                  LengthOptions.new(value.to_h)
                elsif value.is_a? LengthOptions
                  value
                elsif value.nil?
                  LengthOptions.new
                else
                  raise ArgumentError,
                        "`value` should be a #{Hash} or #{LengthOptions}, but got #{value.class}"
                end
    end

    def interpret_to(model, field_name, accessibility, options = {})
      super
      length.interpret_to model, field_name, accessibility, options
    end

    class LengthOptions < ::OptionsModel
      attribute_names.merge [:minimum, :maximum, :is]

      def minimum
        attributes.fetch(:minimum) { 0 }
      end

      def minimum=(value)
        attributes[:minimum] = ActiveModel::Type.lookup(:integer).cast(value)
      end

      def maximum
        attributes.fetch(:maximum) { 0 }
      end

      def maximum=(value)
        attributes[:maximum] = ActiveModel::Type.lookup(:integer).cast(value)
      end

      def is
        attributes.fetch(:is) { 0 }
      end

      def is=(value)
        attributes[:is] = ActiveModel::Type.lookup(:integer).cast(value)
      end

      validates :minimum, :maximum, :is,
                numericality: {
                  greater_than_or_equal_to: 0
                }
      validates :maximum,
                numericality: {
                  greater_than: :minimum
                },
                if: proc { |record| record.maximum <= record.minimum && record.maximum.positive? }

      validates :is,
                numericality: {
                  equal_to: 0
                },
                if: proc { |record| !record.maximum.zero? || !record.minimum.zero? }

      def interpret_to(model, field_name, _accessibility, _options = {})
        return if self.minimum.zero? && self.maximum.zero? && self.is.zero?

        if is.positive?
          model.validates field_name, length: {is: is}, allow_blank: true
          return
        end

        options = {}
        options[:minimum] = minimum if minimum.positive?
        options[:maximum] = maximum if maximum.positive?
        return if options.empty?

        model.validates field_name, length: options, allow_blank: true
      end
    end
  end
end
