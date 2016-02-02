class NegativePointsController < ApplicationController
  before_action :set_negative_point, only: [:show, :edit, :update, :destroy]

  ALL_ROLE = []
  ASTEK_ROLE = ALL_ROLE + ["index", "show", "attribution", "attribution_create", "undo_attribution"]
  include RoleHelper
  before_action { redirect_to root_path unless check_role @user, ALL_ROLE, ASTEK_ROLE}


  # GET /negative_points
  # GET /negative_points.json
  def index
    @negative_points = NegativePoint.all.order('points DESC')
  end

  # GET /negative_points/1
  # GET /negative_points/1.json
  def show
  end

  def attribution
  end

  def attribution_create
      negative_point = NegativePoint.find(params[:negative_point])
      if (NegativePoint.get_role "Pedago").include?(negative_point.title)
          r = NegativePoint.attribution(params.extract!(:negative_point, :students), @user)
          notice = "#{r} Negatives points (#{negative_point.title}) created"
      else
          notice = "You are not allowed to perform this action"
      end
      redirect_to negative_points_path, notice: notice
  end

  # Todo: Fix pedago
  def undo_attribution
      negative_point = NegativePoint.find(params[:id])
      p = NegativePointFamilyRelationship.find(params[:attribution_id])
      p.destroy unless p.nil?
      redirect_to negative_points_path(negative_point), notice: "Undo attribution of #{negative_point.title} to #{p.number} #{p.family.name}"
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_negative_point
      @negative_point = NegativePoint.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def negative_point_params
      params[:negative_point]
    end
end
