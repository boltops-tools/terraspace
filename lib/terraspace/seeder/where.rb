class Terraspace::Seeder
  class Where
    def initialize(mod, options={})
      @mod, @options = mod, options
    end

    def dest_path
      if @options[:where] == "app"
        seed_path("app")
      else
        seed_path("config")
      end
    end

    def seed_path(folder)
      "#{Terraspace.root}/#{folder}/#{@mod.build_dir(disable_extra: true)}/tfvars/#{seed_file}.tfvars"
    end

    def seed_file
      [Terraspace.app, Terraspace.role, Terraspace.env, Terraspace.extra].compact.join("/")
    end
  end
end
