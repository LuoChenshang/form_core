class Forms::Fields::ApplicationController < Forms::ApplicationController
  before_action :set_field

  protected

  # Use callbacks to share common setup or constraints between actions.
  def set_field
    @field = @form.fields.find(params[:field_id])
  end
end
