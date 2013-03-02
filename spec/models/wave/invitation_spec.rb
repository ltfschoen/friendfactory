require 'spec_helper'

describe Wave::Invitation do

  # fixtures :sites, :waves
  # set_fixture_class :waves => 'Wave::Base'

  it "finds fully offered invitation waves" do
    pending
    Wave::Invitation.find_all_by_site_and_fully_offered(sites(:positivelyfrisky), 2).should == [ waves(:adam_invitation_wave) ]
    Wave::Invitation.find_all_by_site_and_fully_offered(sites(:positivelyfrisky), 3).should == [ waves(:adam_invitation_wave) ]
  end

  it "doesn't find invitations not fully offered" do
    pending
    Wave::Invitation.find_all_by_site_and_fully_offered(sites(:positivelyfrisky), 4).should == []
  end

  it "find invitations fully offered for one site only" do
    pending
    Wave::Invitation.find_all_by_site_and_fully_offered(sites(:positivelyfrisky), 2).
        map(&:sites).flatten.
        map(&:name).uniq.
        should == [ 'positivelyfrisky' ]
  end

end
