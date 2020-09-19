# Should implement methods:
#
#   key_field: if need to override default key
#   bucket_field: if need to override default bucket
#   download
#
# If need more customization, then override and implement the call method.
#
module Terraspace::Plugin::Summary
  module Interface
    def initialize(info, options={})
      @info, @options = info, options
    end

    # 1. download state files to temp area
    # 2. show resources for each
    def call
      # Note: will not change any of these instance variables unless we note breaking changes
      @bucket = @info[bucket_field]
      @key = @info[key_field] # key_field is INTERFACE METHOD IE: aws: key , google: prefix
      @folder = folder(@key)  # useful as prefix for performance when listing objects in buckets
      @dest = dest(@bucket)
      # May change any of these instance variables that follow
      @dest_folder = "#{@dest}/#{@folder}"

      download_statefiles
      show_resources
    end

    # default because aws and azurerm uses it.
    # google uses prefix
    # interface method
    def key_field
      'key'
    end

    # default because aws and google uses it.
    # azure uses storage_account_name and other attributes
    # interface method
    def bucket_field
      'bucket'
    end

    # Allow override by plugin implementation class. Generally, all files in these folders are tfstate files.
    def statefile_expr
      "#{@dest_folder}**/*"
    end

    def download_statefiles
      return unless download?
      FileUtils.rm_rf(@dest_folder)
      logger.info("Downloading statefiles to #{@dest_folder}")
      download # INTERFACE METHOD
    end

    def show_resources
      Dir.glob(statefile_expr).sort.each do |path|
        next unless File.file?(path)
        next if path.include?(".tflock")
        show_each(path)
      end
      logger.info("No resources found in statefiles") unless @has_shown_resources
    end

    def show_each(path)
      data = JSON.load(IO.read(path))
      resources = data['resources']
      remove_statefile(path) if resources && resources.size == 0 && !ENV['TS_KEEP_EMPTY_STATEFILES']
      return unless resources && resources.size > 0

      pretty_path = path.sub(Regexp.new(".*#{@bucket}/#{@folder}"), '')
      logger.info pretty_path.color(:green)
      resources.each do |r|
        @has_shown_resources = true # flag to note some resources there were shown
        identifier = r['instances'].map do |i|
          i['attributes']['name'] || i['attributes']['id']
        end.join(',')
        return if @options[:short]
        logger.info "    #{r['type']} #{r['name']}: #{identifier}"
      end
    end

    # Clean up empty statefiles because over time the extra network calls to download them
    # slow down the summary command
    def remove_statefile(path)
      key = path.sub("#{statefiles_root}/#{@bucket}/",'')
      delete_empty_statefile(key)
    end

    # interface method
    def delete_empty_statefile(key)
    end

  private
    def folder(path)
      index = locate_env_index(path)
      path[0..index] # Example folder: us-central1/dev/
    end

    # Assume that the state files are within a env folder.
    # IE: us-central1/dev/stacks/vm
    def locate_env_index(path)
      regexp = Regexp.new("/#{Terraspace.env}/")
      index = path.index(regexp)
      unless index
        logger.error "ERROR: Unable to find the #{Terraspace.env} position in the prefix"
        logger.error "path used: #{path}"
        exit 1
      end
      env_chars = Terraspace.env.size + 1
      index + env_chars
    end

    def dest(bucket)
      "#{statefiles_root}/#{bucket}"
    end

    def statefiles_root
      "#{Terraspace.tmp_root}/statefiles"
    end

    def logger
      Terraspace.logger
    end

    def download?
      ENV['TS_SUMMARY_DOWNLOAD'] != '0'
    end
  end
end
