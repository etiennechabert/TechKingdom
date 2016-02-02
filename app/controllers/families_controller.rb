class FamiliesController < ApplicationController
    include FamiliesHelper
    before_action :set_family, only: [:show, :show_members, :bonus_details, :edit, :import_users, :import_users_create, :update, :destroy]

    ALL_ROLE = ["index", "show", "score_details"]
    ASTEK_ROLE = ALL_ROLE + ['bonus_details']
    include RoleHelper
    before_action { redirect_to root_path unless check_role @user, ALL_ROLE, ASTEK_ROLE}

    # GET /families
    # GET /families.json
    def index
        @families = Family.all
        respond_to do |format|
            format.html
            format.json {render json: Family.all_family_details}
        end
    end

    # GET /families/1
    # GET /families/1.json
    def show
        respond_to do |format|
            format.html
            format.json {render json: @family.family_details}
        end
    end

    def bonus_details
        @bonus_details = @family.bonus_details
    end

    def score_details
        result = {}

        Family.all.each do |f|
            result[f.name] = f.score_details
        end
        @score_details = result

        result = []
        PositivePoint.all.each { |p| result << p.title }
        @positive_points = result

        result = []
        NegativePoint.all.each { |p| result << p.title }
        @negative_points = result
    end

    # TODO: Handle the flash error
    # GET /families/new
    def new
        redirect_to families_path, flash: { error: "All room are already used" } if Family.unique_room_list.empty?
        @family = Family.new
    end

    # GET /families/1/edit
    def edit
    end

    def import_users
    end

    def import_users_create
        @family.job_users_create(params, :import_users)
        redirect_to families_path, notice: 'Import in progress'
    end

    def show_members
        @entity = params["entity"].constantize
        @result = @entity.where(family: @family).order("login ASC")
    end

    private
    # Use callbacks to share common setup or constraints between actions.
    def set_family
        @family = Family.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def family_params
        params[:family].permit(:name, :motto, :room)
    end
end
