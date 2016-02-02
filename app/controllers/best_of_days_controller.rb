class BestOfDaysController < ApplicationController
  before_action :set_best_of_day, only: [:show, :edit, :update, :destroy]

  ALL_ROLE = []
  ASTEK_ROLE = ALL_ROLE + []
  include RoleHelper
  before_action { redirect_to root_path unless check_role @user, ALL_ROLE, ASTEK_ROLE}


  # GET /best_of_days
  # GET /best_of_days.json
  def index
    @best_of_days = BestOfDay.all
  end

  def show

  end

  # GET /best_of_days/new
  def new
    @best_of_day = BestOfDay.new
  end

  # POST /best_of_days
  # POST /best_of_days.json
  # todo: fix pedago
  def create
    @best_of_day = BestOfDay.new(best_of_day_params)

    @best_of_day.pedago_id = @user.id
    respond_to do |format|
      if @best_of_day.save
        format.html { redirect_to best_of_days_path, notice: 'Best of day was successfully created.' }
        format.json { render :show, status: :created, location: @best_of_day }
      else
        format.html { render :new }
        format.json { render json: @best_of_day.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /best_of_days/1
  # DELETE /best_of_days/1.json
  def destroy
    @best_of_day.destroy
    respond_to do |format|
      format.html { redirect_to best_of_days_path, notice: 'Best of day was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_best_of_day
      @best_of_day = BestOfDay.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def best_of_day_params
      params.require(:best_of_day).permit(:day, :pedago_id, :commentary, :first, :second, :third, :fourth, :fifth, :sixth, :seventh, :eighth, :ninth, :tenth)
    end
end
