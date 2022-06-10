require "thor"

# Override thor's long_desc identation behavior
# https://github.com/erikhuda/thor/issues/398
class Thor
  module Shell
    class Basic
      def print_wrapped(message, options = {})
        message = "\n#{message}" unless message[0] == "\n"
        stdout.puts message
      end
    end
  end
end

# Gets rid of the c_l_i extra commands in the help menu. Seems like thor_classes_in is only used
# for this purpose. More details: https://gist.github.com/tongueroo/ee92ec28a4d3eed301d88e8ccdd2fe10
module ThorPrepend
  module Util
    def thor_classes_in(klass)
      klass.name.include?("CLI") ? [] : super
    end
  end
end
Thor::Util.singleton_class.prepend(ThorPrepend::Util)

module Terraspace
  class Command < Thor
    class << self
      include Terraspace::Util::Logging

      @@initial_dispatch_command = nil
      def initial_dispatch_command
        @@initial_dispatch_command
      end

      # use by test framework
      def reset_dispatch_command
        @@initial_dispatch_command = nil
      end

      def dispatch(m, args, options, config)
        # Terraspace.argv provides consistency when terraspace is being called by rspec-terraspace test harness
        Terraspace.argv = args.clone # important to clone since Thor removes the first argv

        unless @@initial_dispatch_command
          @@initial_dispatch_command = "$ terraspace #{args.join(' ')}\n"
          Terraspace::Logger.buffer << @@initial_dispatch_command
        end

        check_standalone_install!
        check_project!(args.first)

        # Allow calling for help via:
        #   terraspace command help
        #   terraspace command -h
        #   terraspace command --help
        #   terraspace command -D
        #
        # as well thor's normal way:
        #
        #   terraspace help command
        if args.length > 1 && !(args & help_flags).empty?
          args -= help_flags
          args.insert(-2, "help")
        end

        #   terraspace version
        #   terraspace --version
        #   terraspace -v
        version_flags = ["--version", "-v"]
        if args.length == 1 && !(args & version_flags).empty?
          args = ["version"]
        end

        super
      end

      def help_flags
        Thor::HELP_MAPPINGS + ["help"]
      end
      private :help_flags

      def check_standalone_install!
        return unless opt?
        version_manager = "rvm" if rvm?
        version_manager = "rbenv" if rbenv?
        if rbenv? || rvm?
          $stderr.puts <<~EOL.color(:yellow)
            WARN: It looks like a standalone Terraspace install and #{version_manager} is also in use.
            Different gems from the standalone Terraspace install and #{version_manager} can cause all kinds of trouble.
            Please install Terraspace as a gem instead and remove the standalone Terraspace /opt/terraspace installation.
            See: https://terraspace.cloud/docs/install/gem/
          EOL
        end
      end

      def opt?
        paths = ENV['PATH'].split(':')
        opt = paths.detect { |p| p.include?('/opt/terraspace') }
        opt && File.exist?('/opt/terraspace')
      end

      def rvm?
        paths = ENV['PATH'].split(':')
        rvm = paths.detect { |p| p.include?('/rvm/') || p.include?('/.rvm/') }
        rvm && system("type rvm > /dev/null 2>&1")
      end

      def rbenv?
        paths = ENV['PATH'].split(':')
        rbenv = paths.detect { |p| p.include?('/rbenv/') || p.include?('/.rbenv/') }
        rbenv && system("type rbenv > /dev/null 2>&1")
      end

      def check_project!(command_name)
        return if subcommand?
        return if command_name.nil?
        return if help_flags.include?(Terraspace.argv.last) # IE: -h help
        return if %w[-h -v --version check_setup completion completion_script help new setup test version].include?(command_name)
        return if File.exist?("#{Terraspace.root}/config/app.rb")
        return unless Terraspace.check_project
        logger.error "ERROR: It doesn't look like this is a terraspace project. Are you sure you are in a terraspace project?".color(:red)
        ENV['TS_TEST'] ? raise : exit(1)
      end

      def subcommand?
        !!caller.detect { |l| l.include?('in subcommand') }
      end

      # Override command_help to include the description at the top of the
      # long_description.
      def command_help(shell, command_name)
        meth = normalize_command_name(command_name)
        command = all_commands[meth]
        alter_command_description(command)
        super
      end

      def alter_command_description(command)
        return unless command

        # Add description to beginning of long_description
        long_desc = if command.long_description
            "#{command.description}\n\n#{command.long_description}"
          else
            command.description
          end

        # add reference url to end of the long_description
        unless website.empty?
          full_command = [command.ancestor_name, command.name].compact.join('-')
          url = "#{website}/reference/terraspace-#{full_command}"
          long_desc += "\n\nHelp also available at: #{url}"
        end

        command.long_description = long_desc
      end
      private :alter_command_description

      # meant to be overriden
      def website
        "https://terraspace.cloud"
      end

      # https://github.com/erikhuda/thor/issues/244
      # Deprecation warning: Thor exit with status 0 on errors. To keep this behavior, you must define `exit_on_failure?` in `Lono::CLI`
      # You can silence deprecations warning by setting the environment variable THOR_SILENCE_DEPRECATION.
      def exit_on_failure?
        true
      end
    end
  end
end
