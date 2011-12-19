class Wave::Ambassador < Wave::Profile
  def technical_description
    [ super, slug, person.handle ].compact * ' - '
  end
  
end