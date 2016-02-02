require 'fileutils'
require 'date'

USUAL_SEED_PATH = "./db/seeds.rb"
DEST_SEED_PATH = "./backup/seed_files/"

def get_file_name
    "#{DateTime.now.to_s}.rb"
end

def move_file
    return unless File.file?(USUAL_SEED_PATH)
    FileUtils.mv(USUAL_SEED_PATH, "#{DEST_SEED_PATH}#{get_file_name}")
end

def generate_next_seed
    system("RAILS_ENV=production rake db:seed:dump MODELS='Family, Astek, Student, Pedago, PositivePoint, NegativePoint, BestOfDay, GradesImport, NegativePointFamilyRelationship, PositivePointStudentRelationship' EXCLUDE='id'") 
end

move_file
generate_next_seed
