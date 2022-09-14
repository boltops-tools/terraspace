module Terraspace::Compiler::Erb
  class Rewrite
    def initialize(src_path)
      @src_path = src_path
    end

    def rewrite
      input = IO.read(@src_path)
      output = replace(input)
      tfvar_path = @src_path.sub(Terraspace.root,'')
      temp_path = "/tmp/terraspace/rewrite#{tfvar_path}"
      FileUtils.mkdir_p(File.dirname(temp_path))
      IO.write(temp_path, output)
      temp_path
    end

    # Replace contents so only the `output` and `depends_on` are evaluated
    def replace(input)
      lines = input.split("\n").map {|l| l+"\n"} # mimic IO.readlines
      new_lines = lines.map do |line|
        new_line(line)
      end
      new_lines.join('')
    end

    def new_line(line)
      md = line.match(/.*(<% |<%=)/) || line.match(/.*<%$/)
      if md
        words = %w[output depends_on]
        dependency_words = [Terraspace.config.build.dependency_words].flatten
        words += dependency_words # custom user words to evaluated in first pass also
        return line if words.include?('*') # passthrough for special case '*'
        # IE: <%= output or <% depends_on
        regexp = Regexp.new(".*<%.*#{words.join('|')}.*")
        if line.match(regexp)
          line # passthrough
        else
          line.sub('<%', '<%#') # replace with ERB opening comment
        end
      else
        line # passthrough
      end
    end
  end
end
