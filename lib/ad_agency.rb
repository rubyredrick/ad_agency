require 'rake'
require 'rake/tasklib'
require 'jeweler'

class Jeweler
  # Rake tasks for announcing a Jeweler gem.
  #
  # Jeweler::Tasks.new needs to be used before this.
  #
  # Basic usage:
  #
  #     Jeweler::AdAgencyTasks.new
  #
  # Easy enough, right?
  class AdAgencyTasks < ::Rake::TaskLib
    attr_accessor :jeweler

    def initialize
      self.jeweler = Rake.application.jeweler
      define
    end

    def define
      namespace :advertise do
        desc "generate an announcement email body"
        task :email_body do
          spec = jeweler.gemspec
          version = File.readlines("VERSION").first.chomp
          maj_min = version[/^\d+\.\d+/]
          puts "Announcing #{spec.name} version #{version}"
          puts spec.summary
          puts
          puts spec.description
          puts
          if File.exist?("History.txt")
            puts "Changes:"
            puts
            File.readlines("History.txt").each do |line|
              if line =~ /^=+\s+(\d+\.\d+)\./
                break unless $1 == maj_min
              end
              puts line
            end
          end
        end
      end
    end
  end
end
