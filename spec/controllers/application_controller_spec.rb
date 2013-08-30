require "spec_helper"

describe ApplicationController do

  fixtures :sites

  it { should be_an_instance_of ApplicationController }
  it { should be_an ActionController::Base }

  describe "#current_site" do
    subject { controller.send(:current_site) }

    context "invalid" do
      let(:site) { "dummy.com" }
      before { request.stub(:host).and_return(site) }
      it { should be_false }
    end

    context "valid" do
      context "production urls" do
        let(:site) { sites(:friskyhands) }
        before { request.stub(:host).and_return("#{site.name}.com") }
        it { should eq site }
      end

      context "development urls" do
        let(:site) { "friskyhands.localhost" }
        before { request.stub(:host).and_return(site) }
        it { should eq sites(:friskyhands) }
      end
    end
  end

end
