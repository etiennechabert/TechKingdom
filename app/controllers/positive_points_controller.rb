class PositivePointsController < ApplicationController
  before_action :set_positive_point, only: [:show, :edit, :update, :destroy]

  ALL_ROLE = []
  ASTEK_ROLE = ALL_ROLE + ["index", "show", "attribution", "attribution_create", "undo_attribution"]
  include RoleHelper
  before_action { redirect_to root_path unless check_role @user, ALL_ROLE, ASTEK_ROLE}

  # GET /positive_points
  # GET /positive_points.json
  def index
    @positive_points = PositivePoint.all.order('points DESC')
  end

  # GET /positive_points/1
  # GET /positive_points/1.json
  def show
  end

  def attribution
  end

  # todo: fix pedago
  def attribution_create
      positive_point = PositivePoint.find(params[:positive_point])
      if (PositivePoint.get_role "Pedago").include?(positive_point.title)
          r = PositivePoint.attribution(params.extract!(:positive_point, :students), @user)
          notice = "#{r} Positives points (#{positive_point.title}) created"
      else
          notice = "You are not allowed to perform this action"
      end
      redirect_to positive_points_path, notice: notice
  end

  def undo_attribution
      positive_point = PositivePoint.find(params[:id])
      p = PositivePointStudentRelationship.find(params[:attribution_id])
      p.destroy unless p.nil?
      redirect_to positive_point_path(positive_point), notice: "Undo attribution of #{positive_point.title} to #{p.student.login}"
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_positive_point
      @positive_point = PositivePoint.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def positive_point_params
      params[:positive_point]
    end
end
