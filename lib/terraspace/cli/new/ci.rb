class Terraspace::CLI::New
  class Ci < Sequence
    argument :name, required: false

    def self.options
      [
        [:force, aliases: %w[y], type: :boolean, desc: "Bypass overwrite are you sure prompt for existing files"],
      ]
    end
    options.each { |args| class_option(*args) }

    def generate
      unless template_root_exist? # template not provided in the CI plugin
        puts "This CI plugin did not include template. CI plugin: #{meta[:name]}"
        puts "Searched path: #{template_root}"
        exit 1
      end
      set_source_paths(template_root)
      directory ".", exclude_pattern: "partials"
    end

    def make_executable
      exe = meta[:exe]
      return unless exe
      if File.directory?(exe)
        Dir.glob("#{exe}/*").each do |path|
          chmod path, 0755
        end
      else
        chmod exe, 0755
      end
    end

    def message
      puts <<~EOL
        A CI structure has been generated for #{meta[:name]}.
        It's a starter example and should be adjusted for your needs.
      EOL
    end

  private
    def cloud
    # dont use memoize :cloud as Thor Sequence hides the private methods from Memoist
      @cloud ||= Terraspace::Plugin.meta.keys.first # IE: aws azurerm google
    end

    def template_root
      if meta[:root]
        ["#{meta[:root]}/template", @options[:folder]].compact.join('/')
      end
    end

    def template_root_exist?
      template_root && File.exist?(template_root)
    end

    def set_source_paths(*paths)
      # https://github.com/erikhuda/thor/blob/34df888d721ecaa8cf0cea97d51dc6c388002742/lib/thor/actions.rb#L128
      instance_variable_set(:@source_paths, nil) # unset instance variable cache
      # Using string with instance_eval because block doesnt have access to path at runtime.
      self.class.instance_eval %{
        def self.source_paths
          #{paths.flatten.inspect}
        end
      }
    end

    def meta
      if @name
        find_meta
      else
        first_meta
      end
    end

    def find_meta
      found = Terraspace::Cloud::Ci.meta.find do |m|
        m[:name] == @name
      end
      return found if found

      logger.error "Unable to find CI plugin to handle #{@name}".color(:red)
      exit 1
    end

    def first_meta
      first = Terraspace::Cloud::Ci.meta.first
      return first if first

      logger.error "Unable to find Ci class".color(:red)
      logger.error <<~EOL
        Maybe you need to add one of the terraspace_ci_* gems to the Gemfile. IE:

        Gemfile

            gem "terraspace_ci_github"

      EOL
      exit 1
    end

    def partial(path)
      RenderMePretty.result("#{template_root}/partials/#{path}", context: self)
    end

    def plugin_env_vars(indent: 6)
      lines = plugin_env_vars_data.map do |k,v|
        " " * indent + "#{k}: #{v}"
      end
      lines.join("\n") + "\n"
    end

    def plugin_env_vars_data
      name = Terraspace::Plugin.autodetect
      meta = Terraspace::Plugin.meta[name]
      ci_class = meta[:ci_class]
      return {} unless ci_class
      ci_class.new.vars
    end
  end
end
