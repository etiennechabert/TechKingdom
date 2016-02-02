class Family < ActiveRecord::Base
    require     'epitech_api'
    has_many    :asteks, dependent: :destroy
    has_many    :pedagos, dependent: :destroy
    has_many    :students, dependent: :destroy
    has_many    :negative_point_family_relationships, dependent: :destroy
    has_many    :negative_points, through: :negative_point_family_relationships

    # Static values

    before_create    :reset_score

    def self.family_list
        result = []
        Family.all.each {|f| result << ["#{f.name} -- #{f.room}", f.id] }
        result
    end

    def self.list
        result = []
        Family.all.each {|f| result << "#{f.name}"}
        result
    end

    def self.room_list
        ["SM20 - SM21", "SM22", "SM23", "SM24 - 25"]
    end

    def self.upload_users_choices
        ["asteks", "pedagos", "students"].map {|e| e.humanize }
    end

    def self.get_points_field category
        case category
            when PositivePoint.category_list[0]
                'methodology_score'
            when PositivePoint.category_list[1]
                'organization_score'
            when PositivePoint.category_list[2]
                'technical_score'
            else
                raise "unknow category : #{category}"
        end
    end

    def self.all_family_details
        {
            score: Family.all_family_details_score,
            positive_point: PositivePoint.json_data_all,
            negative_point: NegativePoint.json_data_all,
            best_members: self.best_members_all,
            team_ranking: Family.all_family_score,
            stat_details: Family.stat_details
        }
    end

    def self.all_family_score
        r = {}
        Family.all.each do |f|
            r[f.name.downcase] = f.total_score
        end
        r
    end

    def self.all_family_details_score
        r = {methodology_score: 0, organization_score: 0, technical_score: 0}
        Family.all.each do |f|
            [:methodology_score, :organization_score, :technical_score].each do |s|
                r[s] += f[s]
            end
        end
        r
    end

    def reset_score
        self.methodology_score = 0
        self.organization_score = 0
        self.technical_score = 0
        self.total_score = 0
    end

    def bonus_details
        r = []
        self.students.each do |s|
            r <<
                {
                    login: "#{s.login}",
                    night_watch: "#{s.positive_point_student_relationships.where(positive_point: PositivePoint.find_by(title: 'Night Watch')).count}",
                    norme_master: "#{s.positive_point_student_relationships.where(positive_point: PositivePoint.find_by(title: 'Maitre de la norme')).count}"
                }
        end
        r
    end

    def score_details
        positive_points = {}
        positive_points_id = {}
        PositivePoint.all.each { |p| positive_points_id[p.title] = {id: p.id, points: p.points} }

        positive_points_id.each do |title, id|
            positive_points[title] = 0;
        end

        self.students.each do |s|
            positive_points_id.each do |name, hash|
                s.positive_point_student_relationships.where(positive_point_id: hash[:id]).each { |b| positive_points[name] += (hash[:points] * b.multiplier) }
            end
        end

        negative_points = {}
        self.negative_points.each do |p|
            negative_points[p.title] = 0
            p.negative_point_family_relationships.where(family_id: self.id).each do |v|
                negative_points[p.title] += (p.points * v.number)
            end
        end
        {positive_points: positive_points, negative_points: negative_points}
    end

    def best_members
        {
            methodology: best_members_category('methodology_score'),
            organization: best_members_category('organization_score'),
            technical: best_members_category('technical_score'),
            general: best_members_category('total_score')
        }
    end

    def self.calc_malus_total set
        return if set.nil?
        result = 0
        set.each do |s|
            result += s.number
        end
        result
    end

    def self.calc_bonus_total set
        return if set.nil?
        result = 0
        set.each do |s|
            result += s.multiplier
        end
        result
    end

    def self.stat_details family_id = nil
        family_closure = ""
        family_closure = "family_id = #{family_id} AND" unless family_id.nil?

        unless family_id.nil?
            family_member_id = []
            Family.find(family_id).members_id("Student").each {|s| family_member_id << "'#{s}'"}
        end

        student_closure = ""
        student_closure = "student_id IN (#{family_member_id.join(',')}) AND" unless family_id.nil?
        r = {
            norme: {
                daily: calc_malus_total(NegativePointFamilyRelationship.where("#{family_closure} negative_point_id = '#{NegativePoint.find_by(title: 'Norme').id}' AND created_at > '#{(DateTime.now - 1.day).to_s(:db)}'")),
                all:  calc_malus_total(NegativePointFamilyRelationship.where("#{family_closure} negative_point_id = '#{NegativePoint.find_by(title: 'Norme').id}'")),
                bonus: 0
            },
            retard: {
                daily: calc_malus_total(NegativePointFamilyRelationship.where("#{family_closure} negative_point_id = '#{NegativePoint.find_by(title: 'Retard').id}' AND created_at > '#{(DateTime.now - 1.day).to_s(:db)}'")),
                all: calc_malus_total(NegativePointFamilyRelationship.where("#{family_closure} negative_point_id = '#{NegativePoint.find_by(title: 'Retard').id}'")),
                bonus: 0
            },
            points_obtenus: {
                daily: calc_bonus_total(PositivePointStudentRelationship.where("#{student_closure} positive_point_id IN (#{[PositivePoint.find_by(title: 'Bonne note').id, PositivePoint.find_by(title: 'Bonne note (colle/exam)').id].join(',')}) AND created_at > '#{(DateTime.now - 1.day).to_s(:db)}'")),
                all: calc_bonus_total(PositivePointStudentRelationship.where("#{student_closure} positive_point_id IN (#{[PositivePoint.find_by(title: 'Bonne note').id, PositivePoint.find_by(title: 'Bonne note (colle/exam)').id].join(',')})")),
                bonus: 1
            },
            norme_master: {
                daily: PositivePointStudentRelationship.where("#{student_closure} positive_point_id = '#{PositivePoint.find_by(title: 'Maitre de la norme').id}' AND created_at > '#{(DateTime.now - 1.day).to_s(:db)}'").count,
                all: PositivePointStudentRelationship.where("#{student_closure} positive_point_id = '#{PositivePoint.find_by(title: 'Maitre de la norme').id}'").count,
                bonus: 1
            },
            night_watch: {
                daily: PositivePointStudentRelationship.where("#{student_closure} positive_point_id = '#{PositivePoint.find_by(title: 'Night Watch').id}' AND created_at > '#{(DateTime.now - 1.day).to_s(:db)}'").count,
                all: PositivePointStudentRelationship.where("#{student_closure} positive_point_id = '#{PositivePoint.find_by(title: 'Night Watch').id}'").count,
                bonus: 1
            }
        }
    end

    def best_members_category category
        r = []
        self.students.where("#{category} > 0").order("#{category} DESC").limit(20).each do |s|
            r << {
                login: s.login,
                score: s[category],
                family: s.family.name.downcase
            }
        end
        r
    end

    def self.best_members_all
        {
            methodology: best_members_all_category('methodology_score'),
            organization: best_members_all_category('organization_score'),
            technical: best_members_all_category('technical_score'),
            general: best_members_all_category('total_score')
        }
    end

    def self.best_members_all_category category
        r = []
        Student.where("#{category} > 0").order("#{category} DESC").limit(20).each do |s|
            r << {
                login: s.login,
                score: s[category],
                family: s.family.name.downcase
            }
        end
        r
    end

    def family_details
        {
            id: self.id,
            name: self.name.downcase,
            score: self.family_score,
            positive_point: PositivePoint.json_data(self),
            negative_point: NegativePoint.json_data(self),
            best_members: best_members,
            team_ranking: Family.all_family_score,
            stat_details: Family.stat_details(self.id)
        }
    end

    def family_score
        {
            methodology_score: self.methodology_score,
            organization_score: self.organization_score,
            technical_score: self.technical_score,
            total: self.total_score
        }
    end

    validates :name, presence: true
    validates :motto, presence: true
    validates :room, inclusion: { in: room_list }

    before_save { self.name = self.name.humanize }
    before_save { self.motto = self.motto.humanize }

    def self.unique_room_list
        room_list - Family.pluck(:room)
    end

    def self.best_score
        best = -100000000
        Family.all.each { |f| best = f.score if f.score > best }
        best
    end

    def job_users_create params, import_users
        FamiliesHelper.handle_csv_file(self.name, params[:file], import_users)
        delayed_job_users_create(import_users, params[:users])
    end

    def entity_numbers entity
        entity.constantize.where(family: self).count
    end

    def members_id entity
        r = []
        entity.constantize.where(family_id: self.id).each do |e|
            r << e.id
        end
        r
    end

    def score
        methodology_score + organization_score + technical_score
    end

    def pourcent_score score_value
        ((score_value.to_f / score.to_f) * 100).round 1
    end

    def positive_point_students
        students_id = []
        self.students.each do |s|
            students_id << s.id
        end
        ::PositivePointStudentRelationship.where(student_id: students_id).order('created_at DESC')
    end

    private

    def delayed_job_users_create import_users, user_type
        result = FamiliesHelper.parse_csv_file(self.name, import_users)
        result.each do |r|
            delayed_job_users_create_category r, user_type
        end
    end

    def delayed_job_users_create_category user_hash, user_type
        user_type = user_type.downcase
        case user_type
            when 'asteks'
                ::Astek.create_try user_hash, self
            when 'pedagos'
                ::Pedago.create_try user_hash, self
            when 'students'
                ::Student.create_try user_hash, self
            end
    end

    #handle_asynchronously :delayed_job_users_create
    #handle_asynchronously :delayed_job_users_create_category
end
