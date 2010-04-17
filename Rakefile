require 'rubygems'
require 'rake'

begin
  require 'ad_agency'
  Jeweler::Tasks.new do |gem|
    gem.name = "ad_agency"
    gem.summary = %Q{An extension to Jeweler for generating announcements}
    gem.description = %Q{
One of the facilities I missed in moving from hoe to jeweler was the ability to easily
announce new versions of gems.

ad_agency fills that hole.
    }
    gem.email = "rick.denatale@gmail.com"
    gem.homepage = "http://github.com/rubyredrick/ad_agency"
    gem.authors = ["Rick DeNatale"]
    gem.add_development_dependency "rspec", ">= 1.2.9"
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
  Jeweler::GemcutterTasks.new
  Jeweler::AdAgencyTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

require 'spec/rake/spectask'
Spec::Rake::SpecTask.new(:spec) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.spec_files = FileList['spec/**/*_spec.rb']
end

Spec::Rake::SpecTask.new(:rcov) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.pattern = 'spec/**/*_spec.rb'
  spec.rcov = true
end

task :spec => :check_dependencies

task :default => :spec

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "ad_agency #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
