class UsersController < ApplicationController
  before_action :set_user, only: [:edit, :update]
  
  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.order(created_at: :desc)
  end
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
    else
      render 'new'
    end
  end
  
  def edit
  end
  
  def update
    #binding.pry
    if params[:user][:new_password].blank? || params[:user][:new_password_confirmation].blank?
      if @user.update(user_params)
        # 保存に成功した場合はトップページへリダイレクト
        redirect_to user_path(@user) , alert: 'メッセージを編集しました'
      else
        # 保存に失敗した場合は編集画面へ戻す
        flash.now[:alert] = "失敗１"
        render 'edit'
      end 
    elsif @user && @user.authenticate(params[:user][:password_for_edit]) && params[:user][:new_password]==params[:user][:new_password_confirmation]
      params[:user][:password] = params[:user][:new_password]
      params[:user][:password_confirmation] = params[:user][:new_password_confirmation]
      if @user.update(user_params)
        # 保存に成功した場合はトップページへリダイレクト
        redirect_to user_path(@user) , alert: 'メッセージを編集しました'
      else
        # 保存に失敗した場合は編集画面へ戻す
        flash.now[:alert] = "失敗２"
        render 'edit'
      end
    else
      flash.now[:alert] = '現在のパスワードor確認用パスワードが間違っています。'
      render 'edit'
    end
  end
  
  def followings
    @user = User.find(params[:id])
    @followings = @user.following_relationships #.order(created_at: :desc)
  end
  
  def followers
    @user = User.find(params[:id])
    @followers = @user.follower_relationships.order(created_at: :desc)
  end
  
  private
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :residence, :detail)
    
  end
  
  def set_user
    @user = User.find(params[:id])
    if @user != current_user
      redirect_to root_path, alert: "別のユーザーの編集はできません。"
    end
  end

end
