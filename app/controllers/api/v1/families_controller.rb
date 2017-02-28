class Api::V1::FamiliesController < Api::BaseController
  protect_from_forgery with: :null_session
  
  before_action :set_family, only: [:show, :edit, :update, :destroy]
  respond_to :json

  # GET /families.json
  def index
    @families = Family.all
  end

  # GET /families/1.json
  def show
    render json: @family.as_json(children: true, parents: true), status: 200
  end

  # POST /families.json
  def create
    @family = Family.new(family_params)

    if @family.save
      render :show, status: :created, location: @family
    else
      render json: @family.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /families/1.json
  def update
    if @family.update(family_params)
      render :show, status: :ok, location: @family
    else
      render json: @family.errors, status: :unprocessable_entity
    end
  end

  # DELETE /families/1.json
  def destroy
    @family.destroy
    head :no_content
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_family
      @family = Family.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def family_params
      params.require(:family).permit(:name, :address)
    end
end
