require 'test_helper'

class PedagosControllerTest < ActionController::TestCase
  setup do
    @pedago = pedagos(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:pedagos)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create pedago" do
    assert_difference('Pedago.count') do
      post :create, pedago: {  }
    end

    assert_redirected_to pedago_path(assigns(:pedago))
  end

  test "should show pedago" do
    get :show, id: @pedago
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @pedago
    assert_response :success
  end

  test "should update pedago" do
    patch :update, id: @pedago, pedago: {  }
    assert_redirected_to pedago_path(assigns(:pedago))
  end

  test "should destroy pedago" do
    assert_difference('Pedago.count', -1) do
      delete :destroy, id: @pedago
    end

    assert_redirected_to pedagos_path
  end
end
