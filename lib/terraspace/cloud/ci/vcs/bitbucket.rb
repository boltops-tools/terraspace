class Terraspace::Cloud::Ci::Vcs
  class Bitbucket < Base
    def commit_url
      "#{host}/#{full_repo}/commits/#{sha}" if sha
    end

    def branch_url
      "#{host}/#{full_repo}/branch/#{branch_name}" if branch_name
    end
  end
end
