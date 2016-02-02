class CreateFamilies < ActiveRecord::Migration
    def change
        create_table :families do |t|
            t.string    :name
            t.string    :motto
            t.string    :room
            t.integer   :methodology_score, default: 0
            t.integer   :organization_score, default: 0
            t.integer   :technical_score, default: 0
            t.integer   :total_score, default: 0
            t.timestamps
        end
    end
end
