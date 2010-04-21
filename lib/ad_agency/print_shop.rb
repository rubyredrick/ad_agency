module AdAgency
  class PrintShop
    
    def self.get_version
      File.readlines("VERSION").first.chomp
    end
    
    def self.history_file?
      File.exist?("History.txt")
    end
    
    def self.history_lines
      File.readlines("History.txt")
    end
      
    def self.print_ad(spec, outfile=STDOUT)
      version = get_version
      maj_min = version[/^\d+\.\d+/]
      outfile.puts "Announcing #{spec.name} version #{version}"
      outfile.puts spec.summary
      outfile.puts
      outfile.puts spec.description
      outfile.puts
      if history_file?
        outfile.puts "Changes:"
        outfile.puts
        history_lines.each do |line|
          if line =~ /^=+\s+v?(\d+\.\d+)\./
            break unless $1 == maj_min
          end
          outfile.puts line
        end
      end
    end
  end
end
