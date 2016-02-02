require 'test_helper'

class PositivePointsControllerTest < ActionController::TestCase
  setup do
    @positive_point = positive_points(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:positive_points)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create positive_point" do
    assert_difference('PositivePoint.count') do
      post :create, positive_point: {  }
    end

    assert_redirected_to positive_point_path(assigns(:positive_point))
  end

  test "should show positive_point" do
    get :show, id: @positive_point
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @positive_point
    assert_response :success
  end

  test "should update positive_point" do
    patch :update, id: @positive_point, positive_point: {  }
    assert_redirected_to positive_point_path(assigns(:positive_point))
  end

  test "should destroy positive_point" do
    assert_difference('PositivePoint.count', -1) do
      delete :destroy, id: @positive_point
    end

    assert_redirected_to positive_points_path
  end
end
