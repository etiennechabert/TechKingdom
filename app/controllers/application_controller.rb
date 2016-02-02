class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action {@user = eval(session["user"]) unless session["user"].nil?}

  def login_create
      login = params[:login]
      user = Astek.find_by(login: login[:login])
      user = Pedago.find_by(login: login[:login]) if user.nil?
      login_create_session user, login[:password]
      redirect_to root_path
  end

  def logout
      @user = session["user"] = nil
      redirect_to root_path
  end

  private

  def login_create_session user, password
      return if user.nil?
      result = EpitechApi.authentification(user.login, password)["result"]
      return if result["state"] == "KO"
      session["user"] = "#{user.class.name}.find(#{user.id})"
  end
end
