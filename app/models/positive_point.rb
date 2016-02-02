class PositivePoint < ActiveRecord::Base
    include Concerns::PointConcern

    has_many :positive_point_student_relationships, dependent: :destroy
    has_many :students, through: :positive_point_student_relationships
    has_many :asteks, through: :positive_point_student_relationships
    has_many :pedagos, through: :positive_point_student_relationships

    before_update :undo_old_values
    after_update :apply_old_values

    def self.get_role role
        astek_role if role == "Astek"
        pedago_role if role == "Pedago"
    end

    def self.astek_role
        ["Night watch", "La tour"]
    end

    def self.pedago_role
        r = []
        PositivePoint.all.each { |p| r << p.title}
        r
    end

    def self.list role
        result = []
        PositivePoint.all.each do |p|
            next if role == 'Astek' && astek_role.include?(p.title) == false
            next if role == 'Pedago' && pedago_role.include?(p.title) == false
            result << [p.title, p.id]
        end
        result
    end

    def self.attribution params, user
        return if params[:students].empty?
        students = params[:students].split(';')
        students.each do |s|
            PositivePointStudentRelationship.create(student_id: Student.find_by(login: s).id, pedago_id: user.id, positive_point_id: params[:positive_point])
        end
        students.size
    end

    def self.json_data family
        r = []
        PositivePointStudentRelationship.where(student_id: family.members_id('Student')).limit(15).order('id DESC').each do |n|
            r << {
                id: n.id,
                title: n.positive_point.title,
                description: n.positive_point.description,
                login: n.student.login,
                score: n.positive_point.points * n.multiplier,
                category: n.positive_point.category.downcase,
                family: family.name.downcase
            }
        end
        r
    end

    def self.json_data_all
        r = []
        PositivePointStudentRelationship.all.limit(15).order('id DESC').each do |n|
            r << {
                id: n.id,
                title: n.positive_point.title,
                description: n.positive_point.description,
                login: n.student.login,
                score: n.positive_point.points * n.multiplier,
                category: n.positive_point.category.downcase,
                family: n.student.family.name.downcase
            }
        end
        r
    end
end
