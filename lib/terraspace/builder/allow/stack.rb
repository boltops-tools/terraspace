class Terraspace::Builder::Allow
  class Stack < Base
    # interface method
    def message
      messages = []
      messages << "This stack is not allowed to be used for TS_ENV=#{Terraspace.env}"
      messages << "Allow stacks: #{allows.join(', ')}" if allows
      messages << "Deny stacks: #{denys.join(', ')}" if denys
      messages.join("\n")
    end

    # interface method
    def check_value
      @mod.name
    end
  end
end
