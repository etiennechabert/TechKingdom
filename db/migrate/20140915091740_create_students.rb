class CreateStudents < ActiveRecord::Migration
    def change
        create_table :students do |t|
            t.string    :login
            t.string    :name
            t.integer   :family_id
            t.integer   :methodology_score, default: 0
            t.integer   :organization_score, default: 0
            t.integer   :technical_score, default: 0
            t.integer   :total_score, default: 0

            t.timestamps
        end
    end
end
