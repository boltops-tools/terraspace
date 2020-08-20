class Terraspace::Terraform::Api
  module Client
    extend Memoist

    def http
      Http.new
    end
    memoize :http
  end
end
