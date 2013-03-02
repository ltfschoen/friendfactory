require 'spec_helper'

describe 'admin/invitation/universals/index.haml' do

  # set_fixture_class :postings => 'Posting::Base'
  # fixtures :sites, :postings

  # let(:invitation) { postings(:invitation_posting_for_anonymous) }

  before(:each) do
    # view.stub!(:current_site).and_return(sites(:positivelyfrisky))
    # assign(:postings, [ invitation ])
  end

  it "renders inviter's handle" do
    pending
    render
    rendered.should contain('AdamA')
  end

  it "renders universal invitation code" do
    pending
    render
    rendered.should contain('e5')
  end

  it "renders the invitation's state" do
    pending
    render
    rendered.should contain('Offered')
  end

end
