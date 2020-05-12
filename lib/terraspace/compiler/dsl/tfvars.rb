module Terraspace::Compiler::Dsl
  class Tfvars < Base
    include Terraspace::Compiler::Dsl::Syntax::Tfvar

    # Can return nil if there's no tfvars declared
    def build
      evaluate(@src_path)
      result = @structure.deep_stringify_keys
      JSON.pretty_generate(result) unless result.empty?
    end

    def evaluate(path)
      current_instance_vars = instance_variables
      evaluate_file(path) # tfvar calls creates variables in @structure
      new_instance_vars = instance_variables - current_instance_vars
      add_instance_vars!(new_instance_vars)
    end

    def add_instance_vars!(new_instance_vars)
      # IE: new_instance_variables = [:@cidr_block, :@name]
      @structure.deep_stringify_keys!
      new_instance_vars.each do |var|
        key = var.to_s.sub('@','') # better to keep String as tfvar will usually use String notation, also deep_stringify_keys! earlier just in case
        value = instance_variable_get(var)
        @structure.merge!(key => value)
      end
    end
  end
end
