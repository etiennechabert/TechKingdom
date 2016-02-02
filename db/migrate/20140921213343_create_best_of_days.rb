class CreateBestOfDays < ActiveRecord::Migration
    def change
        create_table :best_of_days do |t|
            t.date      :day
            t.integer   :pedago_id
            t.string    :commentary, default: ''
            t.string   :first
            t.string   :second
            t.string   :third
            t.string   :fourth
            t.string   :fifth
            t.string   :sixth
            t.string   :seventh
            t.string   :eighth
            t.string   :ninth
            t.string   :tenth

            t.timestamps
        end
    end
end
