module Terraspace::Compiler::Dsl::Decorators
  class AwsSecurityGroup < Base
    def decorate!
      ingress = @props[:ingress]
      return @props unless ingress

      @props[:ingress] = [ingress] if ingress.is_a?(Hash)

      # expect Array
      ingress_array!
    end

    # json format requires sending all props
    # see: https://github.com/terraform-providers/terraform-provider-aws/issues/8786
    def ingress_array!
      @props[:ingress].map! do |i|
        i[:cidr_blocks] ||= nil
        i[:ipv6_cidr_blocks] ||= nil
        i[:prefix_list_ids] ||= nil
        i[:security_groups] ||= nil
        i[:self] ||= nil
        i
      end
    end
  end
end
