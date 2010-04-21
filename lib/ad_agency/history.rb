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
      `git log --format=format:"commit-%h %cd %s %b" --date=short`.split
    end
    
    def tag_and_commit(string)
      if /^([^-]+)-\d+-g(.+)$/ =~ string
        [$1, $2]
      else
        [nil, nil]
      end
    end
    
    def cleanup(string)
      string.sub(/^=*\s*([vV](ersion)?)?\d+\.\d+\.\d+\s+(-\s+\d+\s+[^ ]*\s+(\d\d\d\d)?-?\s+)?/ , "")
    end

    def generate(output = STDOUT)
      @tag_for_commit = {}
      git_tags.each do |tag|
        tag, commit = *tag_and_commit(git_describe(tag))
        @tag_for_commit[commit] = tag if tag
      end
      commit_regexp = %r{^(#{@tag_for_commit.keys.join("|")})}
      git_log.each do |line|
        if /^commit-([^ ]+) ([^ ]+) (.*$)/ =~ line
          sha, date, description = $1, $2, $3
          if commit_regexp =~ sha
            output.puts("=== #{@tag_for_commit[$1]} #{date}")
          end
          output.puts "   #{cleanup(description)}"
        else
          output.puts "   #{cleanup(line)}"
        end
      end
    end
  end
end