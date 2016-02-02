module Concerns
    module UserConcern
        extend  ActiveSupport::Concern

        module ClassMethods
            def create_try hash, family
                return unless self.find_by(login: hash['Login']).nil?
                unless (self.name == "Student")
                    hash = EpitechApi.get_details(hash.first[1])
                    return unless hash['error'] == 'none'
                    hash = hash['result']
                else
                    hash = {"login" => hash.first[1]}
                end
                hash['family_id'] = family.id
                self.create(hash)
            end
        end

        included do
            validates :login, presence: true, uniqueness: true
            validates :family_id, presence: true
        end
    end
end
