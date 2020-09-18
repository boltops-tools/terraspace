class Terraspace::Terraform::Api::Http
  module Concern
    extend Memoist

    def http
      Terraspace::Terraform::Api::Http.new
    end
    memoize :http
  end
end
