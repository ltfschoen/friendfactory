require 'spec_helper'

describe Wave::ProfileController do
    
  fixtures :users, :waves
  
  describe 'not logged in' do
    describe "GET show" do
      it "should redirect to welcome controller" do
        get 'show'
        response.should redirect_to(welcome_path)
      end
    end
  end
  
  describe 'logged in' do
    before(:each) do
      controller.stub(:current_user).and_return(users(:adam))
    end

    describe "GET show" do
      it 'assigns @profile' do
        pending
        get :show
        assigns[:profile].should == users(:adam).profile
      end
      
      it 'renders show' do
        pending
        get :show
        response.should render_template('wave/profile/show')
      end
    end
    
    describe 'XHR avatar' do      
      let(:image) do
        File.join(Rails.root, 'test', 'fixtures', 'images', 'avatars', 'adam-02.jpg')
      end
      
      it 'renders avatar' do
        pending
        xhr :post, :avatar, :posting_avatar => { :image => fixture_file_upload(image, 'image/jpeg') }
        response.should render_template('wave/profile/avatar')        
      end
      
      it 'creates an avatar posting' do
        pending
        expect {
          xhr :post, :avatar, :posting_avatar => { :image => fixture_file_upload(image, 'image/jpeg') }
        }.to change{ users(:adam).profile.avatars.count }.by(1)
      end      
    end
  end

end
