module FormCore::Concerns
  module Models
    module Form
      extend ActiveSupport::Concern

      included do
        has_many :fields
      end

      DEFAULT_MODEL_NAME = "Form"
      DEFAULT_FIELDS_SCOPE = proc { |fields| fields }
      def to_virtual_model(model_name: DEFAULT_MODEL_NAME,
                           fields_scope: DEFAULT_FIELDS_SCOPE,
                           overrides: {})
        model = Class.new(FormCore.virtual_model_class)
        model.model_name = model_name

        fields_scope.call(fields).each do |f|
          f.interpret_to model, overrides: overrides.fetch(f.name, {})
        end

        model
      end
    end
  end
end
