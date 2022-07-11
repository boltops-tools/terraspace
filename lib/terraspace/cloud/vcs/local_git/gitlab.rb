class Terraspace::Cloud::Vcs::LocalGit
  class Gitlab < Base
    def commit_url
      "#{host}/#{full_repo}/-/commits/#{sha}" if sha
    end

    def branch_url
      "#{host}/#{full_repo}/-/tree/#{branch_name}" if branch_name
    end

    # Also computed in ci plugins which detects it from the ci env.
    # Also handling here for case when user provides PR_NUMBER and GIT_REPO outside of normal CI env.
    def pr_url
      "#{host}/#{full_repo}/-/merge_requests/#{pr_number}" if pr_number
    end
  end
end
