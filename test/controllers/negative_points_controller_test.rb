require 'test_helper'

class NegativePointsControllerTest < ActionController::TestCase
  setup do
    @negative_point = negative_points(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:negative_points)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create negative_point" do
    assert_difference('NegativePoint.count') do
      post :create, negative_point: {  }
    end

    assert_redirected_to negative_point_path(assigns(:negative_point))
  end

  test "should show negative_point" do
    get :show, id: @negative_point
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @negative_point
    assert_response :success
  end

  test "should update negative_point" do
    patch :update, id: @negative_point, negative_point: {  }
    assert_redirected_to negative_point_path(assigns(:negative_point))
  end

  test "should destroy negative_point" do
    assert_difference('NegativePoint.count', -1) do
      delete :destroy, id: @negative_point
    end

    assert_redirected_to negative_points_path
  end
end
