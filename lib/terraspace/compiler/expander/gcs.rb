require "gcp_data"

class Terraspace::Compiler::Expander
  class Gcs < Base
    delegate :project, :region, to: :gcp_data

    def gcp_data
      $__gcp_data ||= GcpData
    end
  end
end
