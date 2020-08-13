require "hcl_parser"

module Terraspace
  class Seeder
    extend Memoist
    include Terraspace::Util

    def initialize(mod, options={})
      @mod, @options = mod, options
    end

    def seed
      parsed = parse # make @parsed available for rest of processing
      content = Content.new(parsed).build
      write(content)
    end

    def parse
      if exist?("variables.tf")
        load_hcl_variables
      elsif exist?("variables.tf.json")
        JSON.load(read("variables.tf.json"))
      else
        logger.warn "WARN: no variables.tf or variables.tf.json found in: #{@mod.cache_dir}"
        ENV['TS_TEST'] ? raise : exit
      end
    end
    memoize :parse

    def load_hcl_variables
      HclParser.load(read("variables.tf"))
    rescue Racc::ParseError => e
      logger.error "ERROR: Unable to parse the #{Util.pretty_path(@mod.cache_dir)}/variables.tf file".color(:red)
      logger.error "and generate the starter tfvars file. This is probably due to a complex variable type."
      logger.error "#{e.class}: #{e.message}"
      puts
      logger.error "You will have to create the tfvars file manually at: #{Util.pretty_path(dest_path)}"
      exit 1
    end

    def write(content)
      actions.create_file(dest_path, content)
    end

    def dest_path
      Where.new(@mod, @options).dest_path
    end
    memoize :dest_path

    def exist?(file)
      path = "#{@mod.cache_dir}/#{file}"
      File.exist?(path)
    end

    def read(file)
      path = "#{@mod.cache_dir}/#{file}"
      logger.info "Reading: #{Util.pretty_path(path)}"
      IO.read(path)
    end

    def actions
      Actions.new(@options)
    end
    memoize :actions
  end
end
