class Admin::OperatorsController < AdminController

	before_action :find_operator, only: [:edit, :update]

	def index
    @operators = policy_scope(Operator).paginate(page: params[:page], per_page: 10)
  end

  def new
    @operator = Operator.new
    authorize @operator
  end

  def create
    @operator = Operator.new(operator_params)
    authorize @operator
    if @operator.save!
      redirect_to admin_operators_path, notice: "Operator created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    authorize @operator
  end

  def update
    authorize @operator
    if @operator.update(operator_params)
      redirect_to admin_operators_path, notice: "Operator updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def operator_params
    params.require(:operator).permit(:name, :user_id, :rating)
  end

  def find_operator
    @operator = Operator.find(params[:id])
  end
end
