module Fields::Options
  class TextField < ::OptionsModel
    def multiline
      attributes.fetch(:multiline) { false }
    end
    alias_method :multiline?, :multiline

    def multiline=(val)
      attributes[:multiline] = ActiveModel::Type.lookup(:boolean).cast(val)
    end

    self.attribute_names << :multiline
  end
end
