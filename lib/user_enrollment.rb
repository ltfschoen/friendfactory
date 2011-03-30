module UserEnrollment

  def new_user_enrollment(attrs)
    if user = User.find_by_email(attrs[:email])
      user.enroll(current_site, attrs[:handle], attrs[:invitation_code])   
    else
      User.new_user_with_enrollment(current_site, attrs)
    end
  end
  
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
