require "spec_helper"

describe "Papercrop::Cropbox" do

  before do
    @landscape         = Landscape.new(:name => "Mountains")
    @landscape.picture = open(mountains_img_path)
    @landscape.save

    @cropbox = Papercrop::Cropbox.new(@landscape, :picture)
  end


  it "sets up geometry" do
    @cropbox.instance_variable_get(:@geometry).kind_of?(Paperclip::Geometry).should be(true)
    @cropbox.geometry?.should be(true)
    @cropbox.original_width.should eq(1024)
    @cropbox.original_height.should eq(768)
  end


  it "doesn't crash if the attachment is blank" do
    @landscape.picture = nil
    cropbox = Papercrop::Cropbox.new(@landscape, :picture)

    cropbox.geometry?.should be(false)
  end


  it "parses jcrop opts" do
    opts = @cropbox.parse_jcrop_opts({})

    opts[:aspect_ratio].should eq(1.3333333333333333)
    opts[:set_select].should eq([0, 0, 512, 384])

    opts = @cropbox.parse_jcrop_opts(:width => 1200, :aspect => 1.5, :set_select => [50, 50, 400, 300], :max_size => [1200, 900], :bg_color => '#884433')

    opts[:box_width].should eq(1200)
    opts[:aspect_ratio].should eq(1.5)
    opts[:set_select].should eq([50, 50, 400, 300])
    opts[:max_size].should eq([1200, 900])
    opts[:bg_color].should eq('#884433')

    opts = @cropbox.parse_jcrop_opts(:box_width => 1200, :aspect => false)

    opts[:box_width].should eq(1200)
    opts[:aspect_ratio].should be(false)
  end
end