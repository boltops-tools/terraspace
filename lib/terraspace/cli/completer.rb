# begin
# Code Explanation:
#
# There are 3 types of things to auto-complete:
#
#   1. command: the command itself
#   2. parameters: command parameters.
#   3. options: command options
#
# Here's an example:
#
#   mycli hello name --from me
#
#   * command: hello
#   * parameters: name
#   * option: --from
#
# When command parameters are done processing, the remaining completion words will be options.  We can tell that the command params are completed based on the method arity.
#
# ## Arity
#
# For example, say you had a method for a CLI command with the following form:
#
#   terraspace up STACK
#
# It's equivalent ruby method:
#
#   up(mod) = has an arity of 1
#
# So typing:
#
#   terraspace up [TAB] # there is parameter including the "scale" command according to Thor's CLI processing.
#
# So the completion should only show options, something like this:
#
#   --noop --verbose --cluster
#
# ## Splat Arguments
#
# When the ruby method has a splat argument, it's arity is negative.  Here are some example methods and their arities.
#
#   up(mod) = 1
#   scale(service, count) = 2
#   bundle(*args) = -1
#   foo(example, *rest) = -2
#
# Fortunately, negative and positive arity values are processed the same way. So we take simply take the absolute value of the arity and process it the same.
#
# Here are some test cases, hit TAB after typing the command:
#
#   terraspace completion
#   terraspace completion up
#   terraspace completion up name
#   terraspace completion up name --
#   terraspace completion up name --noop
#
# ## Subcommands and Thor::Group Registered Commands
#
# Sometimes the commands are not simple thor commands but are subcommands or Thor::Group commands. A good specific example is the terraspace tool.
#
#   * regular command: terraspace up
#   * subcommand: terraspace all
#   * Thor::Group command: terraspace new project

# Auto-completion accounts for each of these type of commands.
class Terraspace::CLI
  class Completer
    def initialize(command_class, *params)
      @params = params
      @current_command = @params[0]
      @command_class = command_class # CLI initiall
    end

    def run
      if subcommand?(@current_command)
        subcommand_class = @command_class.subcommand_classes[@current_command]
        @params.shift # destructive
        Completer.new(subcommand_class, *@params).run # recursively use subcommand
        return
      end

      # full command has been found!
      unless found?(@current_command)
        puts all_commands
        return
      end

      # will only get to here if command aws found (above)
      arity = @command_class.instance_method(@current_command).arity.abs
      if @params.size > arity or thor_group_command?
        puts options_completion
      else
        puts params_completion
      end
    end

    def subcommand?(command)
      @command_class.subcommands.include?(command)
    end

    # hacky way to detect that command is a registered Thor::Group command
    def thor_group_command?
      command_params(raw=true) == [[:rest, :args]]
    end

    def found?(command)
      public_methods = @command_class.public_instance_methods(false)
      command && public_methods.include?(command.to_sym)
    end

    # all top-level commands
    def all_commands
      commands = @command_class.all_commands.reject do |k,v|
        v.is_a?(Thor::HiddenCommand)
      end
      commands.keys
    end

    def command_params(raw=false)
      params = @command_class.instance_method(@current_command).parameters
      # Example:
      # >> Sub.instance_method(:goodbye).parameters
      # => [[:req, :name]]
      # >>
      raw ? params : params.map!(&:last)
    end

    def params_completion
      offset = @params.size - 1
      command_params[offset..-1].first
    end

    def options_completion
      used = ARGV.select { |a| a.include?('--') } # so we can remove used options

      method_options = @command_class.all_commands[@current_command].options.keys
      class_options = @command_class.class_options.keys

      all_options = method_options + class_options + ['help']

      all_options.map! { |o| "--#{o.to_s.gsub('_','-')}" }
      filtered_options = all_options - used
      filtered_options.uniq
    end

    # Useful for debugging. Using puts messes up completion.
    def log(msg)
      File.open("/tmp/complete.log", "a") do |file|
        file.puts(msg)
      end
    end
  end
end
