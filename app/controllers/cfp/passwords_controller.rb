class Cfp::PasswordsController < FrabApplicationController

  layout "signup"

  def new
    @user = User.new
  end

  def create
    @user = User.find_by_email(params[:user][:email])
    if @user and @user.send_password_reset_instructions(@conference.call_for_papers)
      redirect_to new_cfp_session_path, :notice => t(:"cfp.sent_password_reset_instructions")
    else
      flash[:alert] = t(:"cfp.problem_sending_password_reset_instructions")
      redirect_to new_cfp_user_password_path
    end
  end

  def edit
    @user = User.new
    @user.reset_password_token = params[:reset_password_token]
  end

  def update
    @user = User.find_by_reset_password_token(params[:user][:reset_password_token])
    if @user and @user.reset_password(params[:user])
      login_as @user
      redirect_to cfp_person_path, :notice => t(:"cfp.password_updated")
    else
      @user.reset_password_token = params[:user][:reset_password_token]
      render :action => "edit"
    end
  end

end
