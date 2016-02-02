require 'families_helper'

class GradesImport < ActiveRecord::Base
    has_many :positive_point_student_relationships, dependent: :destroy
    has_many :negative_point_family_relationships, dependent: :destroy
    has_many :students, through: :positive_point_student_relationships

    validates :date, presence: true #uniqueness: true
    validates_numericality_of :minimal_exercise, presence: true

    def self.try_new user, params
        file = params.extract!(:file)
        import = self.create(params)
        return import unless import.valid?
        import.handle_file(user, file[:file])
        import
    end

    def handle_file user, file
        FamiliesHelper.handle_csv_file self.class.name, file, 'import'
        parsing_import user
    end

    def parsing_import user
        hash_result = FamiliesHelper.parse_csv_file self.class.name, 'import'
        norme_total = {}
        Family.list.each { |f| norme_total[f] = 0 }
        hash_result.each do |e|
            commentaire = ''
            commentaire = e['Commentaire'].split(',') unless e['Commentaire'].nil?
            parsing_import_each e.first[1], e['Note'], user, commentaire, norme_total
        end
        create_negative_point_norme user, norme_total
    end

    def parsing_import_each login, grade, user, data_array, norme_total
        hash_result = {success: 0, norme_master: false}
        (0...data_array.size).each do |i|
            hash_result[:success] += 1 if data_array[i].include? "OK"
            hash_result[:norme_master] = !(data_array[i].include? "check the norm twice") if i == data_array.size - 1
        end
        hash_result[:norme_value] = /\((.*)\)/.match(data_array.last)
        hash_result[:norme_value] = eval(hash_result[:norme_value][1]) unless hash_result[:norme_value].nil?
        hash_result[:norme_value] = 0 if hash_result[:norme_value].nil?
        add_grade_positive_points login, grade, user
        create_norme_master_entry(login, user) if hash_result[:norme_master] && hash_result[:success] >= self.minimal_exercise
        count_negative_point_norme(login, hash_result[:norme_value], norme_total) unless hash_result[:norme_value] == 0
    end

    def add_grade_positive_points login, grade, user
        grade.gsub!(',', '.')
        grade = grade.to_f
        student = Student.find_by(login: login)
        return if student.nil?
        return unless grade > 0
        unless self.exam_colle
            r = PositivePointStudentRelationship.new(student_id: student.id, pedago_id: user.id, grades_import_id: self.id, positive_point_id: PositivePoint.find_by(title: 'Bonne note').id, multiplier: grade)
        else
            r = PositivePointStudentRelationship.new(student_id: student.id, pedago_id: user.id, grades_import_id: self.id, positive_point_id: PositivePoint.find_by(title: 'Bonne note (colle/exam)').id, multiplier: grade)
        end
        r.validate_time = false
        r.save
    end

    def create_norme_master_entry login, user
        student = Student.find_by(login: login)
        return if student.nil?
        r = PositivePointStudentRelationship.new(pedago_id: user.id, student: Student.find_by(login: login), grades_import_id: self.id, positive_point_id: PositivePoint.find_by(title: "Maitre de la norme").id)
        r.validate_time = false
        r.save
    end

    def count_negative_point_norme login, value, norme_total
        student = Student.find_by(login: login)
        return if student.nil?
        norme_total[student.family.name] += value
    end

    def create_negative_point_norme user, norme_total
        norme_total.each do |f,v|
            v = v.abs
            r = NegativePointFamilyRelationship.new(family_id: Family.find_by(name: f).id, negative_point_id: NegativePoint.find_by(title: 'Norme').id, pedago_id: user.id, grades_import_id: self.id, number: (v * (self.norme_tolerance / 100.0))) unless v == 0
            r.save unless v == 0
        end
    end

    # handle_asynchronously :parsing_import
end
