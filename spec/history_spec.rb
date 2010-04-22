require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'lib/ad_agency/history.rb'
require 'yaml'

describe "History" do
  
  def fixture_file(name)
    File.expand_path(File.dirname(__FILE__) + "/fixture_data/#{name}")
  end
  
  before(:all) do
    @example_tag_descriptor = {}
    File.readlines(fixture_file('example_tag_descriptors')).each do |line|
      if /^([^-]+)-\d+-g/ =~ line
        @example_tag_descriptor[$1] = line
      end
    end
    @example_tags = File.readlines(fixture_file('example_tags')).map {|line| line.chomp}
    @example_log = File.readlines(fixture_file('example_gitlog'))
    @expected_history = File.read(fixture_file('expected_history.txt'))
  end
  
  describe "#tag_and_commit" do
    AdAgency::History.new.tag_and_commit("v0.8.7-0-g2dbcdf8").should == [
      "v0.8.7", 
      "2dbcdf8"
      ]
  end
  
  describe "#generate" do
    before(:each) do
      @it = AdAgency::History.new
      @output = StringIO.new
      @it.stub(:git_tags).and_return(["v0.8.7"])
      @it.stub(:git_log).and_return([])
      @it.stub(:get_current_version).and_return("0.8.8")
      Date.stub(:today).and_return(Date.parse("20100421"))
    end
        
    it "should produce a map of commits to tags" do
      @it.stub(:git_describe).and_return("v0.8.7-0-g2dbcdf8")
      @it.generate(@output)
      @it.tag_for_commit.should == {"2dbcdf8" => "v0.8.7"}
    end
    
    it "should produce the correct output" do
        @it.stub(:git_tags).and_return(@example_tags)
        @it.stub(:git_log).and_return(@example_log)
        @it.stub(:git_describe) do |tag|
          @example_tag_descriptor[tag]
        end
        @it.generate(@output)
        @output.string.should == @expected_history
    end
  end
end
