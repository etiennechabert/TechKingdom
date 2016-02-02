class AddColumPositivePointStudentRelationships < ActiveRecord::Migration
  def change
      add_column :positive_point_student_relationships, :multiplier, :integer, default: 1
  end
end
