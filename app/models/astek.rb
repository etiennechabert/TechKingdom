class Astek < ActiveRecord::Base
    include Concerns::UserConcern

    belongs_to :family
    has_many :positive_point_family_relationships, dependent: :destroy
    has_many :positive_points, through: :positive_point_family_relationships
end
