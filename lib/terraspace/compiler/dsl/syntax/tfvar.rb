module Terraspace::Compiler::Dsl::Syntax
  module Tfvar
    # Include all modules within the syntax/mod folder. IE:
    #
    #    include Common
    #    include Provider
    #    # etc
    #
    syntax = File.expand_path("tfvar", __dir__)
    Dir.glob("#{syntax}/**/*").each do |path|
      regexp = Regexp.new(".*/lib/")
      klass = path.sub(regexp, '').sub('.rb','').camelize
      include klass.constantize
    end
  end
end
