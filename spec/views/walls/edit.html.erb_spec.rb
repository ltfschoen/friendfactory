require 'spec_helper'

describe "/walls/edit.html.erb" do
  include WallsHelper

  before(:each) do
    assigns[:wall] = @wall = stub_model(Wall,
      :new_record? => false,
      :type => "value for type"
    )
  end

  it "renders the edit wall form" do
    render

    response.should have_tag("form[action=#{wall_path(@wall)}][method=post]") do
      with_tag('input#wall_type[name=?]', "wall[type]")
    end
  end
end
