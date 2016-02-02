class Student < ActiveRecord::Base
    include Concerns::UserConcern

    belongs_to :family
    has_many :positive_point_student_relationships, dependent: :destroy
    has_many :positive_points, through: :positive_point_student_relationships

    before_create :reset_score

    def reset_score
        self.methodology_score = 0
        self.technical_score = 0
        self.organization_score = 0
        self.total_score = 0
    end

    def self.get_list
        result = []
        Student.all.each  {|s| result << s.login}
        result.to_json
    end
end
