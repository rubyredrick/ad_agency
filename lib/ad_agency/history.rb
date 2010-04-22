require 'date'
module AdAgency
  class History
    attr_reader :tag_for_commit
    
    def git_tags
      `git tag`.split.map {|raw| raw.chomp}
    end
    
    def git_describe(tag)
      `git describe --tags --long #{tag}`.chomp
    end
    
    def git_log
      `git log --format=format:"commit-%h %cd %s %b" --date=short`.split("\n")
    end
    
    def tag_and_commit(string)
      if /^([^-]+)-\d+-g(.+)$/ =~ string
        [$1, $2]
      else
        [nil, nil]
      end
    end
    
    def get_current_version
      File.readlines(
         File.expand_path(File.dirname(__FILE__) + "../../../VERSION")
      ).first.chomp
    end
    
    def cleanup(string)
      string.sub(/^=*\s*([vV](ersion)?)?\d+\.\d+\.\d+\s+(-\s+\d+\s+[^ ]*\s+(\d\d\d\d)?-?\s+)?/ , "")
    end
    
    def tag_description(tag, date)
      "=== #{tag} #{date}"
    end

    def generate(output = STDOUT)
      @tag_for_commit = {}
      current_tag = "v#{get_current_version}"
      git_tags.each do |tag|
        tag, commit = *tag_and_commit(git_describe(tag))
        current_tag = nil if current_tag == tag
        @tag_for_commit[commit] = tag if tag
      end
      output.puts(tag_description(current_tag, Date.today)) if current_tag
      commit_regexp = %r{^(#{@tag_for_commit.keys.join("|")})}
      git_log.each do |line|
        if /^commit-([^ ]+) ([^ ]+) (.*$)/ =~ line
          sha, date, description = $1, $2, $3
          if commit_regexp =~ sha
            output.puts(tag_description(@tag_for_commit[$1], date))
           end
          output.puts "   #{cleanup(description)}"
        else
          output.puts "   #{cleanup(line)}"
        end
      end
    end
  end
end