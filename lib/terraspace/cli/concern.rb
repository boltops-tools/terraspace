class Terraspace::CLI
  module Concern
    extend ActiveSupport::Concern

    class_methods do
      # So the Thor::Parser::Options#parse allows flag switch shorthand notation. IE:
      #
      #    command -abc
      #
      # Is same as:
      #
      #    command -a -b -c
      #
      # This messes up the options like -destroy.
      #
      #    terraspace plan -destroy
      #
      # Since only a single dash (-) is passed. It's interpreted as a bunch of flag switches.
      # Providing -- works just fine
      #
      #    terraspace plan --destroy
      #
      # But it'll be nice if user can use -destroy or --destroy
      #
      # Interestingly, -no-color won't be interpreted by Thor as switch flag due to the - inbetween.
      #
      # Looked into the Thor code:
      #
      #   Thor::Parser::Options#parse https://github.com/rails/thor/blob/5c666b4c25e748e57eec2d529d94c5059030979e/lib/thor/parser/options.rb#L88
      #   Thor::Parser::Options#current_is_switch? https://github.com/rails/thor/blob/5c666b4c25e748e57eec2d529d94c5059030979e/lib/thor/parser/options.rb#L165
      #
      # Overriding the current_is_switch? is dirtier than overriding start
      # and adjusting the argv before passing to Thor.
      #
      # There are only so few Terraform boolean options that are single words. To find (fish shell)
      #
      #     for i in init validate plan apply destroy console fmt force-unlock get graph import login logout output providers refresh show state taint test untaint version workspace ; echo "$i:" ; terraform $i -h | grep '^  -' ; end
      #     for i in init validate plan apply destroy console fmt force-unlock get graph import login logout output providers refresh show state taint test untaint version workspace ; echo "$i:" ; terraform $i -h | grep '^  -' | grep -v =  | sed 's/  -//' | grep -v - | sed -r 's/\s+.*//' | sed 's/^/  /' ; end
      #     for i in init validate plan apply destroy console fmt force-unlock get graph import login logout output providers refresh show state taint test untaint version workspace ; terraform $i -h | grep '^  -' | grep -v =  | sed 's/  -//' | grep -v - | sed -r 's/\s+.*//' ; end | sort | uniq
      #
      def start(argv)
        # Note: help is for terraspace -help
        single_word_boolean_args = %w[
          check
          destroy
          diff
          force
          help
          json
          raw
          reconfigure
          recursive
          upgrade
        ]
        argv.map! do |arg|
          word = arg.sub(/^-/,'')
          if single_word_boolean_args.include?(word)
            # Add double dash (--).
            # Later in Terraspace::Terraform::Args::Pass#args a single dash (-) is ensured.
            "--#{word}" # IE: destroy => --destroy
          else
            arg
          end
        end
        super(argv)
      end

      def main_commands
        %w[
          all
          build
          bundle
          down
          list
          new
          plan
          seed
          up
        ]
      end

      def help(shell, subcommand)
        list = printable_commands(true, subcommand)
        list.sort! { |a, b| a[0] <=> b[0] }
        filter = Proc.new do |command, desc|
          main_commands.detect { |name| command =~ Regexp.new("^terraspace #{name}") }
        end
        main = list.select(&filter)
        other = list.reject(&filter)

        shell.say <<~EOL
          Usage: terraspace COMMAND [args]

          The available commands are listed below.
          The primary workflow commands are given first, followed by
          less common or more advanced commands.
        EOL
        shell.say "\nMain Commands:\n\n"
        shell.print_table(main, indent: 2, truncate: true)
        shell.say "\nOther Commands:\n\n"
        shell.print_table(other, indent: 2, truncate: true)
        shell.say <<~EOL

          For more help on each command, you can use the -h option. Example:

              terraspace up -h

          CLI Reference also available at: https://terraspace.cloud/reference/
        EOL
      end
    end
  end
end
