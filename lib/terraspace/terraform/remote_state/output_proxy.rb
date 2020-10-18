module Terraspace::Terraform::RemoteState
  class OutputProxy
    # raw: can be anything: String, Array, Hash, etc
    # options: original options passed by user from the output helper in tfvars
    attr_reader :raw, :options
    def initialize(mod, raw, options={})
      @mod, @raw, @options = mod, raw, options
      @format = @options[:format]
    end

    # Should always return a String
    def to_s
      if @mod.resolved
        # Dont use Unresolved wrapper because Integer get changed to Strings.
        # Want raw value to be used for the to_json call
        value = @raw.nil? ? mock_or_error : @raw
        value.to_json
      else
        Unresolved.new
      end
    end

    def to_ruby
      data = @raw.nil? ? mock_or_error : @raw
      @mod.resolved ? data : Unresolved.new
    end

  private
    def mock_or_error
      @options[:mock] || @options[:error]
    end
  end
end
