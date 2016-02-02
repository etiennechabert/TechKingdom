module  Concerns
    module  PointConcern
        extend  ActiveSupport::Concern

        module  ClassMethods
            def category_list
                ['Methodology', 'Organization', 'Technical']
            end
        end

        included do
            validates :title, presence: true, uniqueness: true
            validates :description, presence: true
            validates :category, presence: true, inclusion: {in: self.category_list }
            validates_numericality_of :points, presence: true
        end
    end
end