require 'spec_helper'

describe "admin/invitation/personals/index.haml" do

  # set_fixture_class :waves => 'Wave::Base'
  # fixtures :sites, :waves

  let(:wave) { waves(:adam_invitation_wave) }

  before(:each) do
    # view.stub!(:current_site).and_return(sites(:positivelyfrisky))
    # assign(:waves, [ wave ])
  end

  it "renders a table of personal invitation" do
    pending
    render
    rendered.should contain('Adam')
    rendered.should contain('adam@test.com')
  end

  it "renders a li for each posting invitation" do
    pending
    render
    rendered.should have_xpath('//li') do |list_items|
      list_items.length.should == 3
    end
  end

  it "each li contains an image" do
    pending
    render
    rendered.should have_selector('li') do |list_items|
      list_items.should have_selector('img.thumb')
    end
  end

end
