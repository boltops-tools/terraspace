class Terraspace::Terraform::Api::Vars
  class Json < Base
    def vars
      context = Terraspace::Compiler::Erb::Context.new(@mod)
      result = RenderMePretty.result(@vars_path, context: context)

      data = JSON.load(result)
      items = data.select do |item|
        item['data']['type'] == 'vars'
      end
      items.map { |i| i['data']['attributes'] }
    end
  end
end
