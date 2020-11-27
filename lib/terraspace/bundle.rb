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

    extend self
  end
end
