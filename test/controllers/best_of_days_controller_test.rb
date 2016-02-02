require 'test_helper'

class BestOfDaysControllerTest < ActionController::TestCase
  setup do
    @best_of_day = best_of_days(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:best_of_days)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create best_of_day" do
    assert_difference('BestOfDay.count') do
      post :create, best_of_day: {  }
    end

    assert_redirected_to best_of_day_path(assigns(:best_of_day))
  end

  test "should show best_of_day" do
    get :show, id: @best_of_day
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @best_of_day
    assert_response :success
  end

  test "should update best_of_day" do
    patch :update, id: @best_of_day, best_of_day: {  }
    assert_redirected_to best_of_day_path(assigns(:best_of_day))
  end

  test "should destroy best_of_day" do
    assert_difference('BestOfDay.count', -1) do
      delete :destroy, id: @best_of_day
    end

    assert_redirected_to best_of_days_path
  end
end
