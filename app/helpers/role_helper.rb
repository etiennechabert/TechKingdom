module  RoleHelper
    def check_role user, all_role, astek_role
        return true if @user.class.name == "Pedago"
        return true if all_role.include? params['action']
        return true if @user.nil? == false && @user.class.name == "Astek" && astek_role.include?(params['action'])
        return false
    end
end