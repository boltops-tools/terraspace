class Terraspace::Seeder
  class Where
    def initialize(mod, options={})
      @mod, @options = mod, options
    end

    def dest_path
      case @options[:where]
      when "app"
        app_path
      when "seed"
        seed_path
      else
        infer_dest_path
      end
    end

    def infer_dest_path
      @mod.type == "stack" ? app_path : seed_path
    end

    def app_path
      "#{Terraspace.root}/app/#{@mod.build_dir}/tfvars/#{seed_file}.tfvars"
    end

    def seed_path
      "#{Terraspace.root}/seed/tfvars/#{@mod.build_dir}/#{seed_file}.tfvars"
    end

    def seed_file
      @options[:instance] || Terraspace.env
    end
  end
end
