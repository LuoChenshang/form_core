require "duck_record"

module FormCore
  class VirtualModel < ::DuckRecord::Base
    public_class_method :define_method
    class << self
      def model_name=(name)
        @_model_name = ActiveModel::Name.new(self, nil, name.classify)
      end
    end
  end
end
