require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'lib/ad_agency/print_shop.rb'

describe "PrintShop.print_ad" do
  before(:each) do
    AdAgency::PrintShop.stub(:get_version).and_return(@version = "1.1.2")
    @spec = double(
    :name => (@gem_name = "30 Carat Ruby"),
    :summary => (@summary = "a terse summary"),
    :description => (@description = "Brilliant prose")
    )
  end

  context "with a history file" do
    before(:each) do
      AdAgency::PrintShop.stub(:history_file?).and_return(true)
      @relevant_history_lines = [
        "untagged change",
        "== v1.1.1",
        "  some change",
        "  another change",
        "== v1.1.0",
        " new minor version"
        ]
      @hist_lines = @relevant_history_lines + [
        "== v1.0.0",
        "  initial release"
        ]
      AdAgency::PrintShop.stub(:history_lines).and_return(@hist_lines)
    end
    
    it "should output the changes since the last minor version" do
      outfile = StringIO.new
      AdAgency::PrintShop.print_ad(@spec, outfile)
      outfile.string.should == [
        "Announcing #{@gem_name} version #{@version}",
        @summary,
        "",
        @description,
        "",
        "Changes:",
        "",
        @relevant_history_lines.join("\n"),
        ""
        ].join("\n")
      end
    end
  end
