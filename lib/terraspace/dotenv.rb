require 'dotenv'

module Terraspace
  class Dotenv
    def load!
      ::Dotenv.load(*files)
    end

    # dotenv files with the following precedence:
    #
    # - .env.dev.local - Highest precedence
    # - .env.dev
    # - .env.local
    # - .env - Lowest precedence
    #
    def files
      [
        ".env.#{Terraspace.env}.local",
        ".env.#{Terraspace.env}",
        ".env.local",
        ".env",
      ].compact
    end
  end
end
