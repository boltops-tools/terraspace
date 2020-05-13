require "aws_data"

class Terraspace::Compiler::State
  class S3 < Base
    delegate :account, :region, to: :aws_data

    def aws_data
      $__aws_data ||= AwsData.new
    end
  end
end
