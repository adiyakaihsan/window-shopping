class ProductsController < ApplicationController
  before_action :set_product, only: %i[ show edit update destroy ]
  before_action :log_impression, :only=> [:show]

  # GET /products
  def index
    @category_all = Category.all
    if (params[:category] && products = Product.where(category_id: params[:category]))
      @products = products
      @category = Category.where(id: params[:category])
    else
      @products = Product.all
    end
      @products = @products.search(params[:keywords]).paginate(:page => params[:page], :per_page => 9).order('created_at DESC') 
  end

  # GET /products/1
  def show
  end

  # GET /products/new
  def new
    @product = Product.new
  end

  # GET /products/1/edit
  def edit
  end

  # POST /products
  def create
    @product = Product.new(product_params)

    if @product.save
      redirect_to @product, notice: "Product was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /products/1
  def update
    if @product.update(product_params)
      redirect_to @product, notice: "Product was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /products/1
  def destroy
    @product.destroy!
    redirect_to products_url, notice: "Product was successfully destroyed.", status: :see_other
  end

  # count Views (impression on visit)
  def log_impression
    @product = Product.find(params[:id])    
    # this assumes you have a current_user method in your authentication system
    @product.impressions.create(request_id: request.request_id)

  end

  # QUESTION: is it correct to associate Products with other table (Categories) in controller like below?
  # associate categories
  def link_categories
    @product = Product.where(category_id: category_id).includes(:categories)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product
      @product = Product.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def product_params
      params.require(:product).permit(:title, :body, :image, :category_id)
    end
end
