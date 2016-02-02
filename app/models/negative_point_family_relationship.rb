class NegativePointFamilyRelationship < ActiveRecord::Base
    belongs_to :negative_point
    belongs_to :family
    belongs_to :pedago
    belongs_to :grades_import

    validates :negative_point_id, presence: true
    validates :family_id, presence: true

    before_validation   :validates_relation_with_astek_or_pedago
    after_create        :apply_team_points
    after_destroy       :undo_team_points

    def apply_team_points
        self.family[Family.get_points_field(self.negative_point.category)] -= self.negative_point.points * self.number
        self.family.total_score -= self.negative_point.points * self.number
        self.family.save
    end

    def undo_team_points
        self.family[Family.get_points_field(self.negative_point.category)] += self.negative_point.points * self.number
        self.family.total_score += self.negative_point.points * self.number
        self.family.save
    end

    def validates_relation_with_astek_or_pedago
        errors.add(:relation, 'a relation is required with astek or pedago') if self.astek_id.nil? && self.pedago_id.nil?
        true
    end

end
