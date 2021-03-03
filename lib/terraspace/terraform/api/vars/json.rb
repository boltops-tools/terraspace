class Terraspace::Terraform::Api::Vars
  class Json < Base
    def vars
      context = Terraspace::Compiler::Erb::Context.new(@mod)
      result = RenderMePretty.result(@vars_path, context: context)

      data = json_load(result)
      items = data.select do |item|
        item['data']['type'] == 'vars'
      end
      items.map { |i| i['data']['attributes'] }
    end

    def json_load(result)
      JSON.load(result)
    rescue JSON::ParserError => e
      # TODO: show exact line with error
      logger.info("ERROR in json: #{e.class}: #{e.message}")
      path = "/tmp/terraspace/debug/vars.json"
      logger.info("Result also written to #{path} for inspection")
      FileUtils.mkdir_p(File.dirname(path))
      IO.write(path, result)
      exit 1
    end
  end
end
