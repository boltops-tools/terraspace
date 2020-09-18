class Terraspace::Terraform::Api
  class Base
    extend Memoist
    include Http::Concern
    include Terraspace::Util::Logging
  end
end
