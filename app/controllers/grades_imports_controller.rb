class GradesImportsController < ApplicationController
  before_action :set_grades_import, only: [:norme_masters, :edit, :update, :destroy]

  ALL_ROLE = []
  ASTEK_ROLE = ALL_ROLE + []
  include RoleHelper
  before_action { redirect_to root_path unless check_role @user, ALL_ROLE, ASTEK_ROLE}


  # GET /grades_imports
  # GET /grades_imports.json
  def index
    @grades_imports = GradesImport.all
  end

  def norme_masters
      @norme_masters = @grades_import.positive_point_student_relationships.where(positive_point: PositivePoint.find_by(title: 'Maitre de la norme'))
  end

  # GET /grades_imports/new
  def new
    @grades_import = GradesImport.new
  end

  # POST /grades_imports
  # POST /grades_imports.json
  def create
    @grades_import = GradesImport.try_new(@user, grades_import_params)

    respond_to do |format|
      if @grades_import.save
        format.html { redirect_to grades_imports_path, notice: 'Grades import was successfully created.' }
        format.json { render :show, status: :created, location: @grades_import }
      else
        format.html { render :new }
        format.json { render json: @grades_import.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /grades_imports/1
  # DELETE /grades_imports/1.json
  def destroy
    @grades_import.destroy
    respond_to do |format|
      format.html { redirect_to grades_imports_url, notice: 'Grades import was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_grades_import
      @grades_import = GradesImport.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def grades_import_params
      params[:grades_import].permit(:date, :minimal_exercise, :norme_tolerance, :exam_colle, :file)
    end
end
