module Wave::ProfilesHelper
  
  def render_profile_signals(profile)
    String.new.html_safe.tap do |html|
      with_options(:partial => 'wave/profiles/profile_signal', :object => profile) do |profile_signal|
        if current_site.name == 'friskyhands'
          html.safe_concat(profile_signal.render(:locals => { :attribute => :deafness }))
        end
        if current_site.name == 'positivelyfrisky'
          html.safe_concat(profile_signal.render(:locals => { :attribute => :hiv_status, :label => 'HIV Status' }))
        end
        if current_site.name == 'dizmdayz'
          html.safe_concat(profile_signal.render(:locals => { :attribute => :board_type, :label => 'Board' }))
        end
        html.safe_concat(profile_signal.render(:locals => { :attribute => :gender }))
        if [ 'friskyhands', 'positivelyfrisky' ].include?(current_site.name)
          html.safe_concat(profile_signal.render(:locals => { :attribute => :orientation, :label => 'Preference' }))
        end
        html.safe_concat(profile_signal.render(:locals => { :attribute => :relationship }))
        html.safe_concat(profile_signal.render(:locals => { :attribute => :birthday }))
        html.safe_concat(profile_signal.render(:locals => { :attribute => :location }))     
      end
    end
  end

end