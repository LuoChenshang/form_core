module Concerns::OptionsModel
  module Attribute
    extend ActiveSupport::Concern

    included do
      validate do
        self.class.attribute_names.each do |attribute_name|
          attribute = public_send(attribute_name)
          if attribute.is_a?(OptionsModel) && attribute.invalid?
            errors.add attribute_name, :invalid
          end
        end
      end
    end

    def initialize(attributes = {})
      update(attributes)
    end

    def initialize_dup(other)
      super

      update(other)
    end

    def update(other)
      return unless other

      unless other.respond_to?(:to_h)
        raise ArgumentError, "#{other} must be respond to `to_h`"
      end

      other.to_h.each do |k, v|
        if respond_to?("#{k}=")
          public_send("#{k}=", v)
        end
      end
    end

    def [](key)
      public_send(key) if respond_to?(key)
    end

    def []=(key, val)
      setter = "#{key}="
      public_send(setter, val) if respond_to?(setter)
    end

    def fetch(key, default = nil)
      if self.class.attribute_names.exclude?(key.to_sym) && default.nil? && !block_given?
        raise KeyError, "attribute not found"
      end

      value = if respond_to?(key)
                public_send(key)
              elsif default
                default
              end

      return value unless value.nil?

      yield if block_given?
    end

    def to_h
      hash = {}

      self.class.attribute_names.each do |attribute_name|
        attribute = public_send(attribute_name)
        hash[attribute_name] = if attribute.is_a?(OptionsModel)
                                 attribute.to_h
                               else
                                 attribute
                               end
      end

      hash
    end

    def _attributes
      @attributes ||= HashWithIndifferentAccess.new
    end
    private :_attributes
    alias_method :attributes, :_attributes

    module ClassMethods
      def attribute_names
        @attribute_names ||= Set.new
      end
    end
  end
end
