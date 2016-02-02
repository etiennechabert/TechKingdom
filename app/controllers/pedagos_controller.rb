class PedagosController < ApplicationController
  before_action :set_pedago, only: [:show, :edit, :update, :destroy]

  ALL_ROLE = []
  ASTEK_ROLE = ALL_ROLE + ["index", "show"]
  include RoleHelper
  before_action { redirect_to root_path unless check_role @user, ALL_ROLE, ASTEK_ROLE}

  # GET /pedagos
  # GET /pedagos.json
  def index
    @pedagos = Pedago.all
  end

  # GET /pedagos/1
  # GET /pedagos/1.json
  def show
  end

  # GET /pedagos/new
  def new
    @pedago = Pedago.new
  end

  # GET /pedagos/1/edit
  def edit
  end

  # POST /pedagos
  # POST /pedagos.json
  def create
    @pedago = Pedago.new(pedago_params)

    respond_to do |format|
      if @pedago.save
        format.html { redirect_to @pedago, notice: 'Pedago was successfully created.' }
        format.json { render :show, status: :created, location: @pedago }
      else
        format.html { render :new }
        format.json { render json: @pedago.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /pedagos/1
  # PATCH/PUT /pedagos/1.json
  def update
    respond_to do |format|
      if @pedago.update(pedago_params)
        format.html { redirect_to @pedago, notice: 'Pedago was successfully updated.' }
        format.json { render :show, status: :ok, location: @pedago }
      else
        format.html { render :edit }
        format.json { render json: @pedago.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /pedagos/1
  # DELETE /pedagos/1.json
  def destroy
    @pedago.destroy
    respond_to do |format|
      format.html { redirect_to pedagos_url, notice: 'Pedago was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_pedago
      @pedago = Pedago.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def pedago_params
      params[:pedago]
    end
end
