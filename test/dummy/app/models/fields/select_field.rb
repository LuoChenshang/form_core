module Fields
  class SelectField < Field
    serialize :validations, Validations::SelectField
    serialize :options, Options::SelectField

    def stored_type
      :string
    end

    protected

    def interpret_extra_to(model, accessibility, _overrides = {})
      return if accessibility != :editable || !options.strict_select?

      model.validates name, inclusion: {in: options.collection}, allow_blank: true
    end
  end
end
