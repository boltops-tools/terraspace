class Terraspace::Cloud::Vcs
  class CiEnv
    extend Memoist
    include Terraspace::Util::Logging

    def vars
      klass = Terraspace::Cloud::Ci.detect
      if klass
        klass.new.vars.compact # remove items with nil values
      else
        {}
      end
    end
  end
end
