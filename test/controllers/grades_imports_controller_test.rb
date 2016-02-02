require 'test_helper'

class GradesImportsControllerTest < ActionController::TestCase
  setup do
    @grades_import = grades_imports(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:grades_imports)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create grades_import" do
    assert_difference('GradesImport.count') do
      post :create, grades_import: {  }
    end

    assert_redirected_to grades_import_path(assigns(:grades_import))
  end

  test "should show grades_import" do
    get :show, id: @grades_import
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @grades_import
    assert_response :success
  end

  test "should update grades_import" do
    patch :update, id: @grades_import, grades_import: {  }
    assert_redirected_to grades_import_path(assigns(:grades_import))
  end

  test "should destroy grades_import" do
    assert_difference('GradesImport.count', -1) do
      delete :destroy, id: @grades_import
    end

    assert_redirected_to grades_imports_path
  end
end
