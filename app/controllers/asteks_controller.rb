class AsteksController < ApplicationController
  before_action :set_astek, only: [:show, :edit, :update, :destroy]

  ALL_ROLE = []
  ASTEK_ROLE = ALL_ROLE + ["index", "show"]
  include RoleHelper
  before_action { redirect_to root_path unless check_role @user, ALL_ROLE, ASTEK_ROLE}

  # GET /asteks
  # GET /asteks.json
  def index
    @asteks = Astek.all
  end

  # GET /asteks/1
  # GET /asteks/1.json
  def show
  end

  # GET /asteks/new
  def new
    @astek = Astek.new
  end

  # GET /asteks/1/edit
  def edit
  end

  # POST /asteks
  # POST /asteks.json
  def create
    @astek = Astek.new(astek_params)

    respond_to do |format|
      if @astek.save
        format.html { redirect_to @astek, notice: 'Astek was successfully created.' }
        format.json { render :show, status: :created, location: @astek }
      else
        format.html { render :new }
        format.json { render json: @astek.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /asteks/1
  # PATCH/PUT /asteks/1.json
  def update
    respond_to do |format|
      if @astek.update(astek_params)
        format.html { redirect_to @astek, notice: 'Astek was successfully updated.' }
        format.json { render :show, status: :ok, location: @astek }
      else
        format.html { render :edit }
        format.json { render json: @astek.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /asteks/1
  # DELETE /asteks/1.json
  def destroy
    @astek.destroy
    respond_to do |format|
      format.html { redirect_to asteks_url, notice: 'Astek was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_astek
      @astek = Astek.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def astek_params
      params[:astek]
    end
end
