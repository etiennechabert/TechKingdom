class CreatePositivePointStudentRelationships < ActiveRecord::Migration
    def change
        create_table :positive_point_student_relationships do |t|
            t.integer :positive_point_id
            t.integer :best_of_day_id
            t.integer :grades_import_id
            t.integer :student_id
            t.integer :pedago_id
            t.integer :astek_id

            t.timestamps
        end
    end
end
