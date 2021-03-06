require 'rake'
require 'rake/tasklib'
require 'jeweler'

module AdAgency
end

require 'lib/ad_agency/print_shop'
require 'lib/ad_agency/history'

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
          AdAgency::PrintShop.print_ad(jeweler.gemspec)
        end

        desc "generate History.txt from the git log"
        task :gen_history do
          File.open(File.expand_path(File.dirname(__FILE__) + "../../History.txt"), 'w') do |hist_file|
            AdAgency::History.new.generate(hist_file)
          end
        end
      end
    end
  end
end
