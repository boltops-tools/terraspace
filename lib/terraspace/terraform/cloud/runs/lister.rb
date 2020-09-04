require 'cli-format'

class Terraspace::Terraform::Cloud::Runs
  class Lister < Base
    def run
      build_project
      if runs.empty?
        logger.info "No runs found"
        return
      end

      presenter = CliFormat::Presenter.new(@options)
      presenter.header = ["Id", "Status", "Message", "Created At"]
      runs.each do |item|
        p = ItemPresenter.new(item)
        row = [p.id, p.status, p.message, p.created_at]
        presenter.rows << row
      end
      presenter.show
    end
  end
end
