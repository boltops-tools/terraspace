module Terraspace::Terraform::RemoteState
  class OutputProxy
    # raw: can be anything: String, Array, Hash, etc
    # options: original options passed by user with terraform_output
    attr_reader :raw, :options
    def initialize(raw, options={})
      @raw, @options = raw, options
      @format = @options[:format]
    end

    # Should always return a String
    def to_s
      case @format
      when "string"
        content.to_s
      else # "json"
        content.to_json
      end
    end

    def content
      if @raw.nil?
        @options[:mock] || @options[:error]
      else
        @raw
      end
    end
  end
end
