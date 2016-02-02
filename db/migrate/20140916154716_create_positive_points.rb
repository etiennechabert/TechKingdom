class CreatePositivePoints < ActiveRecord::Migration
    def change
        create_table :positive_points do |t|
            t.string :title
            t.string :description
            t.string :category
            t.integer :points

            t.timestamps
        end
    end
end
