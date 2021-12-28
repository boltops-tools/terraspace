module Terraspace::Terraform::Args
  class Pass
    def initialize(mod, name, options={})
      @mod, @name, @options = mod, name.underscore, options
    end

    # map to terraform options and only allow valid terraform options
    # Arg Examples:
    #   -refresh-only
    #   -refresh=false
    #   -var 'foo=bar'
    def args
      args = pass_args.select do |arg|
        arg_name = get_arg_name(arg)
        terraform_arg_types.include?(arg_name)
      end

      args.map { |arg| "-#{arg}" } # add back in the leading single dash (-)
    end

  private
    def pass_args
      args = (@options[:args] || []).map do |o|
        o.sub(/^-{1,2}/,'') # strips the - or --
      end
      reconstruct_hash_args(args)
    end

    # Thor parses CLI args -var 'foo=bar'
    # as:
    #    ["-var", "foo=bar"]
    # instead of:
    #    ["-var 'foo=bar'"]
    #
    # So reconstruct it to what works with terraform CLI args
    def reconstruct_hash_args(args)
      result = []
      flatten = []
      skip = false
      args.each do |arg|
        arg_type = terraform_arg_types[arg]
        if arg_type == :hash || skip
          skip = true
          if flatten.size == 1
            flatten << "'#{arg}'" # surround hash value with single quotes
          else
            flatten << arg
          end
          if flatten.size == 2 # time to grab value and end skipping
            result << flatten.join(' ')
            # reset flags
            skip = false
            flatten = []
          end
          next if skip
        else
          result << arg # boolean (-no-color) or assignment (-refresh=false)
        end
      end
      result
    end

    # Parses terraform COMMAND -help output for arg types.
    # Return Example:
    #
    #     {
    #       destroy: :boolean,
    #       refresh: :assignment,
    #       var: :hash,
    #     }
    #
    def terraform_arg_types
      out = terraform_help(@name)
      lines = out.split("\n")
      lines.select! do |line|
        line =~ /^  -/
      end
      lines.inject({}) do |result, line|
        # in:  "  -replace=resource   Force replacement of a particular resource instance using",
        # out: "-replace=resource   Force replacement of a particular resource instance using",
        line.sub!('  -', '') # remove leading whitespace and -

        # in:  "  -var 'foo=bar'      Set a value for one of the input variables in the root",
        # out: "var"
        # in:  "  -refresh=false      Skip checking for external changes to remote objects",
        # out: "refresh"
        arg_name = get_arg_name(line)

        if line.match(/'\w+=\w+'/)  # hash. IE: -var 'foo=bar'
          result[arg_name] = :hash
        elsif line.match(/\w+=/)    # value IE: -refresh=false
          result[arg_name] = :assignment # can include string and numeric values
        else                        # boolean    IE: -refresh-only
          result[arg_name] = :boolean
        end
        result
      end
    end

    def get_arg_name(line)
      line.sub(/\s+.*/,'').split('=').first # strips everything except arg name only
    end

    @@terraform_help = {}
    def terraform_help(name)
      @@terraform_help[name] ||= `terraform #{name} -help`
    end
  end
end

