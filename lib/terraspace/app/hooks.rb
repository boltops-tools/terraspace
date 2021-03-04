class Terraspace::App
  class Hooks
    # Terraspace.configure do |config|
    #   config.hooks.on_boot do
    #     ENV['AWS_PROFILE'] = 'dev'
    #   end
    # end
    def on_boot(&block)
      # Using puts instead of logger.info because on_boot gets assigned super-early only
      # and logger is set as part of the config/app.rb also. Using puts avoids
      # infinite loop. Will remove this file completely in a future patch release anyway.
      puts <<~EOL.color(:yellow)
        WARN: config.on_boot has been removed. Create a config/boot.rb instead
        See: https://terraspace.cloud/docs/config/boot/
      EOL
    end
  end
end
