class PositivePointStudentRelationship < ActiveRecord::Base
    belongs_to :positive_point
    belongs_to :student
    belongs_to :astek
    belongs_to :pedago
    belongs_to :grades_import
    belongs_to :best_of_day

    validates :positive_point_id, presence: true
    validates :student_id, presence: true

    attr_accessor :validate_time

    before_validation   {@validate_time = true if @validate_time.nil?}
    before_validation   :validates_uniqueness_time
    before_validation   :validates_relation_with_astek_or_pedago
    before_validation   :validates_uniqueness_best_and_grade
    after_create        :apply_student_points
    after_destroy       :undo_student_points

    def validates_uniqueness_best_and_grade
        return if grades_import_id.nil? && best_of_day_id.nil?
        unless grades_import_id.nil?
            errors.add('uniqueness', "Uniqueness on import_id") if PositivePointStudentRelationship.where(student_id: self.student_id, grades_import_id: self.grades_import_id, positive_point_id: self.positive_point_id).count > 0
        end
        unless best_of_day_id.nil?
            errors.add('uniquenss', "Uniqueness on best of day") if PositivePointStudentRelationship.where(student_id: self.student_id, best_of_day_id: self.best_of_day_id).count > 0
        end
    end

    def apply_student_points
        self.student[Family.get_points_field(self.positive_point.category)] += (self.positive_point.points * self.multiplier)
        self.student.total_score += (self.positive_point.points * self.multiplier)
        self.student.save
        self.student.family[Family.get_points_field(self.positive_point.category)] += (self.positive_point.points * self.multiplier)
        self.student.family.total_score += (self.positive_point.points * self.multiplier)
        self.student.family.save
    end

    def undo_student_points
        self.student[Family.get_points_field(self.positive_point.category)] -= (self.positive_point.points * self.multiplier)
        self.student.total_score -= (self.positive_point.points * self.multiplier)
        self.student.save
        self.student.family[Family.get_points_field(self.positive_point.category)] -= (self.positive_point.points * self.multiplier)
        self.student.family.total_score -= (self.positive_point.points * self.multiplier)
        self.student.family.save
    end

    def validates_relation_with_astek_or_pedago
        errors.add('relation', 'a relation is required with astek or pedago') if self.astek_id.nil? && self.pedago_id.nil?
        true
    end

    def validates_uniqueness_time
        return unless @validate_time
        errors.add('uniquenes', 'errors') if self.class.where("created_at > '#{(DateTime.now - 4.hours).to_s(:db)}' && positive_point_id = '#{self.positive_point_id}' && #{self.student_id} = student_id").count > 0
    end

end
