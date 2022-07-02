class Terraspace::Cloud::Vcs
  class LocalEnv < Base
    def vars
      # Do not set any default values. These take highest precedence and will override LocalGit and CiVars
      {
        host: ENV['TS_VCS_HOST'] || ENV['VCS_HOST'] || ENV['GIT_HOST'],
        full_repo: ENV['TS_VCS_REPO'] || ENV['VCS_REPO'] || ENV['GIT_REPO'],
        branch_name: ENV['TS_VCS_BRANCH'],
        # urls
        commit_url: ENV['TS_VCS_COMMIT_URL'],
        branch_url: ENV['TS_VCS_BRANCH_URL'],
        pr_url: ENV['TS_VCS_PR_URL'],
        build_url: ENV['TS_VCS_BUILD_URL'],
        # additional properties
        build_type: ENV['TS_VCS_BUILD_TYPE'],
        # pr_number: ENV['TS_VCS_PR_NUMBER'] || ENV['PR_NUMBER'] || ENV['MR_NUMBER'], # handle in LocalGit::Base so can compute pr_url
        sha: ENV['TS_VCS_SHA'],
        # additional properties
        commit_message: ENV['TS_VCS_COMMIT_MESSAGE'],
        build_id: ENV['TS_VCS_BUILD_ID'],
        build_number: ENV['TS_VCS_BUILD_NUMBER'],
      }.compact # remove items with nil values
    end
  end
end
