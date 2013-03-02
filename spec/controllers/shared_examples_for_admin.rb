shared_examples_for "administrator-only" do |*actions|

  options = actions.extract_options!

  context 'when user not logged in' do
    before(:each) { not_logged_in }
    actions.each do |action|
      it "redirects to welcome page for #{action}" do
        pending
        get action, options
        response.should redirect_to(welcome_url)
      end
    end
  end

  context 'when user logged in' do
    before(:each) { login_as_user }
    actions.each do |action|
      it "redirects to welcome page #{action}" do
        pending
        get action, options
        response.should redirect_to(welcome_url)
      end
    end
  end

end
