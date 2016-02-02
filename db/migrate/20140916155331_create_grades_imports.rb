class CreateGradesImports < ActiveRecord::Migration
    def change
        create_table :grades_imports do |t|
            t.date :date
            t.integer :norme_tolerance, default: 100
            t.integer :minimal_exercise

            t.timestamps
        end
    end
end
