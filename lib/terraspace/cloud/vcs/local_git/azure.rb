class Terraspace::Cloud::Vcs::LocalGit
  class Azure < Base
    def vars
      super.merge(
        host: host,
        full_repo: full_repo,
      )
    end

    def commit_url
      # IE: https://dev.azure.com/tongueroo/infra-project/_git/infra-ci/commit/aaa74f96d76053672ff1b91995c903605cd8a245
      "#{base_repo_url}/commits/#{sha}" if sha
    end

    def base_repo_url
      "#{host}/#{org}/#{project}/_git/#{repo}"
    end

    def branch_url
      # IE: https://dev.azure.com/tongueroo/infra-project/_git/infra-ci?version=GBmerge
      "#{base_repo_url}?verison=GB#{sha}" if sha
    end

    # Also computed in ci plugins which detects it from the ci env.
    # Also handling here for case when user provides PR_NUMBER and GIT_REPO outside of normal CI env.
    def pr_url
      "#{host}/#{full_repo}/pull-requests/#{pr_number}" if pr_number
    end

    # override to remove ssh
    # https://ssh.dev.azure.com => https://dev.azure.com
    def host
      "https://dev.azure.com"
    end

    def url_info
      uri = URI(git_url)
      # IE: v3/tongueroo/infra-project/infra-ci
      uri.path.sub(/^\//,'').split('/') # [version, org, project, repo]
    end

    def org
      version, org, project, repo = url_info
      org
    end

    def repo
      version, org, project, repo = url_info
      repo
    end

    def full_repo
      version, org, project, repo = url_info
      "#{org}/#{repo}"
    end

    def project
      version, org, project, repo = url_info
      project
    end
  end
end
