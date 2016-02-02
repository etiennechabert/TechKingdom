class StudentsController < ApplicationController
  before_action :set_student, only: [:edit, :update, :destroy]

  ALL_ROLE = []
  ASTEK_ROLE = ALL_ROLE + ["index", "show"]
  include RoleHelper
  before_action { redirect_to root_path unless check_role @user, ALL_ROLE, ASTEK_ROLE}


  # GET /students
  # GET /students.json
  def index
    @students = Student.all
  end

  # GET /students/new
  def new
    @student = Student.new
  end

  # GET /students/1/edit
  def edit
  end

  # POST /students
  # POST /students.json
  def create
      student_params
      @student = Student.create_try(student_params,Family.find(student_params["family"]))

      respond_to do |format|
          if @student.errors.empty?
              format.html { redirect_to @student, notice: 'Student was successfully created.' }
              format.json { render :show, status: :created, location: @student }
          else
              format.html { render :new }
              format.json { render json: @student.errors, status: :unprocessable_entity }
          end
      end
  end

  # DELETE /students/1
  # DELETE /students/1.json
  def destroy
    @student.destroy
    respond_to do |format|
      format.html { redirect_to students_url, notice: 'Student was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_student
      @student = Student.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def student_params
      params[:student]
    end
end
