class Terraspace::CLI::New
  class Base < Sequence
    argument :name

    def add_base_files
      set_source("base", "project")
      directory ".", "#{name}"
    end
  end
end
