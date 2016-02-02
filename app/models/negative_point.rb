class NegativePoint < ActiveRecord::Base
    include Concerns::PointConcern

    has_many :negative_point_family_relationships, dependent: :destroy
    has_many :families, through: :negative_point_family_relationships

    before_update :undo_old_values
    after_update :apply_new_values

    def undo_old_values
        self.negative_point_family_relationships.each do |n|
            n.undo_team_points
        end
    end

    def apply_new_values
        self.negative_point_family_relationships.each do |n|
            n.apply_team_points
        end
    end

    def self.get_role role
        astek_role if role == "Astek"
        pedago_role if role == "Pedago"
    end

    def self.astek_role
        []
    end

    def self.pedago_role
        r = []
        NegativePoint.all.each {|n| r << n.title}
        r
    end

    def self.list role
        result = []
        NegativePoint.all.each do |p|
            next if role == 'Astek' && astek_role.include?(p.title) == false
            next if role == 'Pedago' && pedago_role.include?(p.title) == false
            result << [p.title, p.id]
        end
        result
    end

    def self.attribution params, user
        return if params[:students].empty?
        students = params[:students].split(';')
        family_hash = attribution_family students
        family_hash.each do |f,v|
            next if v == 0
            NegativePointFamilyRelationship.create(family_id: Family.find_by(name: f).id, pedago_id: user.id, negative_point_id: params[:negative_point], number: v)
        end
        students.size
    end

    def self.json_data family
        r = []
        NegativePointFamilyRelationship.where(family_id: family.id).limit(15).order('id DESC').each do |n|
            r << {
                id: n.id,
                title: n.negative_point.title,
                description: "#{n.number} #{n.negative_point.description}",
                score: n.negative_point.points * n.number,
                category: n.negative_point.category.downcase,
                family: n.family.name.downcase
            }
        end
        r
    end

    def self.json_data_all
        r = []
        NegativePointFamilyRelationship.all.limit(15).order('id DESC').each do |n|
            r << {
                id: n.id,
                title: n.negative_point.title,
                description: "#{n.number} #{n.negative_point.description}",
                score: n.negative_point.points * n.number,
                category: n.negative_point.category.downcase,
                family: n.family.name.downcase
            }
        end
        r
    end

    private

    def self.attribution_family students
        hash_result = {}
        Family.list.each do |f|
            hash_result[f] = 0
        end

        students.each do |s|
            hash_result[Student.find_by(login: s).family.name] += 1
        end
        hash_result
    end
end
