module Terraspace
  # Named Bundle vs Bundler to avoid having to fully qualify ::Bundler
  module Bundle
    # Looks like for zeitwerk module autovivification to work `bundle exec` must be called.
    # This allows zeitwork module autovivification to work even if the user has not called terraspace with `bundle exec terraspace`.
    # Bundler.setup is essentially the same as `bundle exec`
    # Reference: https://www.justinweiss.com/articles/what-are-the-differences-between-irb/
    #
    def setup
      return unless gemfile?
      return unless terraspace_project?
      Kernel.require "bundler/setup"
      Bundler.setup # Same as Bundler.setup(:default)
    rescue LoadError => e
      handle_error(e)
    end

    def require
      return unless gemfile?
      return unless terraspace_project?
      Kernel.require "bundler/setup"
      Bundler.require(*bundler_groups)
    rescue LoadError => e
      handle_error(e)
    end

    def terraspace_project?
      File.exist?("config/app.rb")
    end

    def handle_error(e)
      puts e.message
      return if e.message.include?("already activated")
      puts <<~EOL.color(:yellow)
        WARNING: Unable to require "bundler/setup"
        There may be something funny with your ruby and bundler setup.
        You can try upgrading bundler and rubygems:

            gem update --system
            gem install bundler

        Here are some links that may be helpful:

        * https://bundler.io/blog/2019/01/03/announcing-bundler-2.html

        Also, running bundle exec in front of your command may remove this message.
      EOL
    end

    def gemfile?
      ENV['BUNDLE_GEMFILE'] || File.exist?("Gemfile")
    end

    def bundler_groups
      [:default, Terraspace.env.to_sym]
    end

    # When there are gem dependency issues, requiring zeitwerk with this debugging code
    #     begin
    #       require "zeitwerk"
    #     rescue LoadError => e
    #       puts "#{e.class}: #{e.message}"
    #       exit 1
    #     end
    #
    # Produces:
    #
    #     You have already activated faraday 1.8.0, but your Gemfile requires faraday 1.7.2. Prepending `bundle exec` to your command may solve this.
    #     LoadError: cannot load such file -- zeitwerk
    #
    # Sadly, the captured exception only contains this info:
    #
    #     LoadError: cannot load such file -- zeitwerk
    #
    # The useful "already activated" info that shows gem dependencies issues. Example:
    #
    #     You have already activated faraday 1.8.0, but your Gemfile requires faraday 1.7.2. Prepending `bundle exec` to your command may solve this.
    #
    # Is printed to stdout earlier and before exception.
    #
    # So making an assumption that a zeitwerk LoadError is due to gem dependencies issue.
    # It's not ideal, but think this is ok.
    #
    # Note: Not checking shim upon install because it wont be a good user experience
    # to check for a shim unless this error actually occurs.
    #
    # Only been able to reproduce this error for a gem install with: alpine
    # The standalone install already has a shim wrapper.
    #
    def handle_already_activated_error(e)
      # color is not yet available
      puts "ERROR: #{e.class}: #{e.message}" if ENV['TS_DEBUG_ALREADY_ACTIVATED']
      check_shim!
      exit 1
    end

    def check_shim!
      return unless File.exist?("Gemfile")
      $stderr.puts <<~EOL
        Looks like there are issues trying to resolve gem dependencies.

        To resolve this, you can generate a shim:

            terraspace new shim

        You only have to do this one time.

        More info: https://terraspace.cloud/docs/install/shim/
      EOL
    end

    extend self
  end
end
