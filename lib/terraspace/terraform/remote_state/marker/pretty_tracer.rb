module Terraspace::Terraform::RemoteState::Marker
  class PrettyTracer
    def initialize(caller_line)
      @caller_line = caller_line
    end

    # /full/path/to/app/stacks/a1/tfvars/dev.tfvars:4:in `__tilt_5560'
    def source_code
      line = @caller_line.sub(/:in `.*/,'')
      path, error_line_number = line.split(':')
      pretty_trace(path, error_line_number.to_i)
    end

    def pretty_trace(path, error_line_number)
      io = StringIO.new
      context = 5 # lines of context
      top, bottom = [error_line_number-context-1, 0].max, error_line_number+context-1

      io.puts "Here's the line in #{Terraspace::Util.pretty_path(path)} with the error:\n\n"

      lines = IO.read(path).split("\n")
      context = 5 # lines of context
      top, bottom = [error_line_number-context-1, 0].max, error_line_number+context-1
      spacing = lines.size.to_s.size
      lines[top..bottom].each_with_index do |line_content, index|
        line_number = top+index+1
        if line_number == error_line_number
          io.printf("%#{spacing}d %s\n".color(:red), line_number, line_content)
        else
          io.printf("%#{spacing}d %s\n", line_number, line_content)
        end
      end

      io.string
    end
  end
end
