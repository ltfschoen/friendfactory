module UserLogin

  def login(params, opts = {})
    opts.reverse_merge!(:skip_enrollment_validation => false)
    @user_session = UserSession.new(params)
    @user_session.remember_me = true
    @user_session.skip_enrollment_validation = opts[:skip_enrollment_validation]
    @user_session.save
  end

  def user_session
    @user_session
  end

end
