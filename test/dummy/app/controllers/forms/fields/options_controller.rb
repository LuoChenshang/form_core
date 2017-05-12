class Forms::Fields::OptionsController < Forms::Fields::ApplicationController
  before_action :set_options

  def edit

  end

  def update
    @options.assign_attributes(options_params)
    if @options.valid? && @field.save(validate: false)
      redirect_to form_fields_url(@form), notice: 'Field was successfully updated.'
    else
      render :edit
    end
  end

  private

  def set_options
    @options = @field.options
  end

  def options_params
    params.fetch(:options, {}).permit!
  end
end
