class Dictionaries::CategoriesController < ApplicationController
  before_action :set_dictionaries_category, only: [:show, :edit, :update, :destroy]

  # GET /dictionaries/categories
  def index
    @dictionaries_categories = Dictionaries::Category.all
  end

  # GET /dictionaries/categories/1
  def show
  end

  # GET /dictionaries/categories/new
  def new
    @dictionaries_category = Dictionaries::Category.new
  end

  # GET /dictionaries/categories/1/edit
  def edit
  end

  # POST /dictionaries/categories
  def create
    @dictionaries_category = Dictionaries::Category.new(dictionaries_category_params)

    if @dictionaries_category.save
      redirect_to @dictionaries_category, notice: 'Category was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /dictionaries/categories/1
  def update
    if @dictionaries_category.update(dictionaries_category_params)
      redirect_to @dictionaries_category, notice: 'Category was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /dictionaries/categories/1
  def destroy
    @dictionaries_category.destroy
    redirect_to dictionaries_categories_url, notice: 'Category was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_dictionaries_category
      @dictionaries_category = Dictionaries::Category.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def dictionaries_category_params
      params.require(:dictionaries_category).permit(:value)
    end
end
