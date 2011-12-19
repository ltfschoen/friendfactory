class Wave::Community < Wave::Base
  def add_posting_to_other_waves(posting)
    add_posting_to_personal_wave(posting)
    super
  end

  def technical_description
    [ super, slug ].compact * ' - '
  end
end