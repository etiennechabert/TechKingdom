class CreatePedagos < ActiveRecord::Migration
    def change
        create_table :pedagos do |t|
            t.string    :login
            t.string    :name
            t.integer   :family_id

            t.timestamps
        end
    end
end
