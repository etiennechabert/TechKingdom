require 'test_helper'

class AsteksControllerTest < ActionController::TestCase
  setup do
    @astek = asteks(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:asteks)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create astek" do
    assert_difference('Astek.count') do
      post :create, astek: {  }
    end

    assert_redirected_to astek_path(assigns(:astek))
  end

  test "should show astek" do
    get :show, id: @astek
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @astek
    assert_response :success
  end

  test "should update astek" do
    patch :update, id: @astek, astek: {  }
    assert_redirected_to astek_path(assigns(:astek))
  end

  test "should destroy astek" do
    assert_difference('Astek.count', -1) do
      delete :destroy, id: @astek
    end

    assert_redirected_to asteks_path
  end
end
