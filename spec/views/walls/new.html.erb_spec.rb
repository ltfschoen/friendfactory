require 'spec_helper'

describe "/walls/new.html.erb" do
  include WallsHelper

  before(:each) do
    assigns[:wall] = stub_model(Wall,
      :new_record? => true,
      :type => "value for type"
    )
  end

  it "renders new wall form" do
    render

    response.should have_tag("form[action=?][method=post]", walls_path) do
      with_tag("input#wall_type[name=?]", "wall[type]")
    end
  end
end
