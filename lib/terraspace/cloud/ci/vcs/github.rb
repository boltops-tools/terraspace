class Terraspace::Cloud::Ci::Vcs
  class Github < Base
    def commit_url
      "#{host}/#{full_repo}/commits/#{sha}" if sha
    end

    def branch_url
      "#{host}/#{full_repo}/tree/#{branch_name}" if branch_name
    end
  end
end
