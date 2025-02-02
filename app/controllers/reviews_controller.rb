class ReviewsController < ApplicationController
  before_action :set_equipment, only: [:create]
  skip_before_action :authenticate_user!, only: [:index]

  def index
    @review = policy_scope(Review).order(created_at: :desc)
    @reviews = Review.all
  end

  def show
    authorize @review
  end


  def new
    @review = Review.new
    authorize @review
  end

  def create
    @review = Review.new(params_review)
    @user = current_user
    @review.user = @user
    @review.equipment = @equipment

    authorize @review

    if @review.save
      respond_to do |format|
        format.html { redirect_to equipment_path(@equipment) }
        format.js  # <-- will render `app/views/reviews/create.js.erb`
      end
    else
      respond_to do |format|
        format.html { render 'equipment/show' }
        format.js  # <-- idem
      end
    end
  end

  def destroy
    @review = Review.find(params[:id])

    @review.destroy
    redirect_to equipment_path(@review.equipment)
    authorize @review
  end

  private

  def set_equipment
    @equipment = Equipment.find(params[:equipment_id])
  end

  def params_review
    params.require(:review).permit(:booking_id, :title, :description)
  end
end
