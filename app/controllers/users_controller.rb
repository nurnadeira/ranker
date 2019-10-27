class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :admin_only, :except => [:show, :index]

  def index
    @users = User.where(role: 'user')
                  .joins(:scores)
                  .select("users.id, users.name, avg(scores.value) as average_score")
                  .group("users.id")
                  .order("average_score DESC")
    @unranked_users = User.includes(:scores).where(role: 'user', scores: {user_id: nil})           
    unless current_user.admin?
      redirect_to user_path(current_user.id)
    end
  end

  def show
    @user = User.find(params[:id])
    @profile = @user.user_profile
    @skills = @user.skills
    @scores = @user.scores.group_by(&:evaluator_id)

    # Get average score of each metric, eg. {'Cooperation' => 3.5 }
    @average_scores = @user.scores.group_by(&:name).map { |key, value| [key, (value.inject(0) { |sum, n| sum + n.value }  / value.size.to_f)]  }.to_h
    @average_score = @user.scores.average(:value)
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(secure_params)
      redirect_to users_path, :notice => "User updated."
    else
      redirect_to users_path, :alert => "Unable to update user."
    end
  end

  def destroy
    user = User.find(params[:id])
    user.destroy
    redirect_to users_path, :notice => "User deleted."
  end

  private

  def admin_only
    unless current_user.admin?
      redirect_to root_path, :alert => "Access denied."
    end
  end

  def secure_params
    params.require(:user).permit(:role)
  end

end
