module Terraspace::Cloud
  class Ci
    # Example meta:
    #
    # [
    #   {name: "github", interface_class: TerrapaceCiGithub::Interface},
    #   {name: "gitlab", interface_class: TerrapaceCiGitlab::Interface},
    # ]
    #
    class_attribute :meta # not shared with child classes
    self.meta = []

    class << self
      def register(data)
        self.meta << data unless meta.find do |m|
          m[:name] == data[:name]
        end
      end

      def detect
        detected = meta.find do |data|
          env_key = data[:env_key] # IE: ENV['GITHUB_ACTIONS']
          env_value = data[:env_value] # IE: "string" or /pattern/
          if env_value
            v = ENV[env_key]
            v && match?(v, env_value)
          else
            ENV[env_key] # only env_key
          end
        end
        interface_class(detected) if detected
      end

      # IE: TerraspaceCiGithub::Interface
      def interface_class(meta)
        "terraspace_ci_#{meta[:name]}::Interface".classify.constantize
      end

      def match?(v, env_value)
        case v
        when String
          v == env_value
        when Regexp
          v.match(env_value)
        end
      end
    end
  end
end
