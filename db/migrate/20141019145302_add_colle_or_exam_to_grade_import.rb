class AddColleOrExamToGradeImport < ActiveRecord::Migration
  def change
      add_column :grades_imports, :exam_colle, :boolean, default: 0
  end
end
