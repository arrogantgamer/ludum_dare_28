require "active_record"

class SessionsController < ApplicationController

  def create
    session[:access_token] = request.env['omniauth.auth']['credentials']['token']
    session[:access_token_secret] = request.env['omniauth.auth']['credentials']['secret']
    redirect_to show_path, :notice => "Signed in"
  end

  def show
    @receiver = Hero.new

    if session['access_token'] && session['access_token_secret']

      @user = client.user(:include_entities => true)
      screen_name = @user.screen_name.downcase
      @hero = Hero.find_or_create_by(handle: screen_name) do |hero|
          hero.hp = 1
          hero.room = 0
          hero.sword = false
      end

      session['user'] = screen_name
    else
      redirect_to failure_path
    end
  end

  def error
    flash[:error] = "Sign in with Twitter failed"
    redirect_to root_path
  end

  def destroy
    reset_session
    redirect_to root_path, :notice => "Signed out"
  end

end
