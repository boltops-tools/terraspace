class Terraspace::New
  class Base < Sequence
    argument :name

    def set_source_path
      set_base_source("project")
    end

    def add_base_files
      directory ".", "#{name}"
    end
  end
end
