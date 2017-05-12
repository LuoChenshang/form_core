module Fields::Options
  class SelectField < ::OptionsModel
    def collection
      attributes.fetch(:collection) { [] }
    end

    def collection=(value)
      attributes[:collection] = if value.is_a?(Array) || value.respond_to?(:to_a)
                                  value.to_a
                                elsif value.nil?
                                  []
                                else
                                  raise ArgumentError,
                                        "`value` should be #{Array} or could respond to `to_a`, but got #{value.class} -- #{value.inspect}"
                                end
    end

    def strict_select
      attributes.fetch(:strict_select) { true }
    end
    alias_method :strict_select?, :strict_select

    def strict_select=(value)
      attributes[:strict_select] = ActiveModel::Type.lookup(:boolean).cast(value)
    end

    attribute_names.merge [:collection, :strict_select]
  end
end
