require 'bcrypt'

class TopController < ApplicationController
  def main
    if session[:login_uid].nil?
      render "login"
    else
      render "main"
    end
  end

  def login
    uid = params[:uid]
    pass = params[:pass]

    user = User.find_by(uid: uid)
    if user.nil?
      render "error", status: 422
      return
    end

    begin
      hashed = BCrypt::Password.new(user.pass)
    rescue BCrypt::Errors::InvalidHash
      render "error", status: 422
      return
    end

    if hashed == pass
      session[:login_uid] = uid
      redirect_to top_main_path
    else
      render "error", status: 422
    end
  end

  def logout
    session.delete(:login_uid)
    redirect_to root_path
  end
end
