class Pedago < ActiveRecord::Base
    include Concerns::UserConcern

    belongs_to :family
    has_many :negative_point_family_relationships
    has_many :negative_points, through: :negative_point_family_relationships
    has_many :positive_point_family_relationships
    has_many :positive_points, through: :positive_point_family_relationships
end
