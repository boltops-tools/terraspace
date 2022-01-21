class Terraspace::Builder::Allow
  class Env < Base
    # interface method
    def message
      messages = []
      messages << "This env is not allowed to be used: TS_ENV=#{Terraspace.env}"
      messages << "Allow envs: #{allows.join(', ')}" if allows
      messages << "Deny envs: #{denys.join(', ')}" if denys
      messages.join("\n")
    end

    # interface method
    def check_value
      Terraspace.env
    end
  end
end
