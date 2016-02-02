class CreateNegativePointFamilyRelationships < ActiveRecord::Migration
  def change
    create_table :negative_point_family_relationships do |t|
        t.integer :negative_point_id
        t.integer :number, default: 1
        t.integer :family_id
        t.integer :pedago_id
        t.integer :astek_id
        t.integer :grades_import_id

      t.timestamps
    end
  end
end
