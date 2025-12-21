class Admin::OperatorsController < AdminController

	before_action :find_operator, only: [:edit, :update]

	def index
    @operators = Operator.all.paginate(page: params[:page], per_page: 10)
  end

  def new
    @operator = Operator.new
  end

  def create
    @operator = Operator.new(operator_params)
    if @operator.save!
      redirect_to admin_operators_path, notice: "Operator created."
    else
      render :new
    end
  end

  def update
    if @operator.update(operator_params)
      redirect_to admin_operators_path, notice: "Operator updated."
    else
      render :edit
    end
  end

  private

  def operator_params
    params.require(:operator).permit(:name, :user_id)
  end

  def find_operator
    @operator = Operator.find(params[:id])
  end
end
