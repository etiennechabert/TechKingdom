class BestOfDay < ActiveRecord::Base
    has_many :positive_point_student_relationships, dependent: :destroy
    has_many :students, through: :positive_point_student_relationships
    has_many :positive_points, through: :positive_point_student_relationships

    after_validation :check_unique_values
    after_create :create_positive_points

    validates :day, presence: true, uniqueness: true
    validates :pedago_id, presence: true

    def self.field_names
        [:first, :second, :third, :fourth, :fifth, :sixth, :seventh, :eighth, :ninth, :tenth]
    end

    BestOfDay.field_names.each do |f|
        validates f, presence: true
    end

    def self.diamond
        [field_names[0]]
    end

    def self.gold
        field_names[1..2]
    end

    def self.silver
        field_names[3..5]
    end

    def self.bronze
        field_names[6..9]
    end

    def self.replace_id_value value
        s = Student.find_by(login: value)
        if s.nil?
            nil
        else
            s.id
        end
    end

    def check_login_values
        BestOfDay.field_names.each do |f|
            self.errors.add(f, ": #{self[f]} doesn t exist") if Student.find_by(login: self[f]).nil?
        end
    end

    def check_unique_values
        return unless self.errors.blank?
        BestOfDay.field_names.each do |f1|
            BestOfDay.field_names.each do |f2|
                next if f1 == f2
                self.errors.add("#{f1.to_s}-#{f2.to_s}", "Can't be the same") if self[f1] == self[f2]
            end
        end
        check_login_values
    end

    def create_positive_points
        return unless self.errors.blank?
        create_positive_points_category BestOfDay.diamond, 'Chevalier de diamant'
        create_positive_points_category BestOfDay.gold, 'Chevalier d\'or'
        create_positive_points_category BestOfDay.silver, 'Chevalier d\'argent'
        create_positive_points_category BestOfDay.bronze, 'Chevalier de bronze'
    end

    private

    # Todo: Fix pedago.first
    def create_positive_points_category field_names, bonus_name
        field_names.each do |f|
            hash = {
                positive_point_id: ::PositivePoint.find_by(title: bonus_name).id,
                best_of_day_id: self.id,
                student_id: ::Student.find_by(login: self[f]).id,
                pedago_id: self.pedago_id
            }
            e = PositivePointStudentRelationship.new(hash)
            e.validate_time = false
            e.save
        end
    end

end
