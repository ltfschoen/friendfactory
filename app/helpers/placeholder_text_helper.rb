module PlaceholderTextHelper

  def placeholder_for(field)
    case field.to_sym
    when :email      then 'email@address.com'
    when :password   then 'password'
    else field.to_s.humanize.downcase
    end
  end
  
end