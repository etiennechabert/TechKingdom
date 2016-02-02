class CreateNegativePoints < ActiveRecord::Migration
    def change
        create_table :negative_points do |t|
            t.string :title
            t.string :description
            t.string :category
            t.integer :points
            t.integer :mult, default: 1

            t.timestamps
        end
    end
end
