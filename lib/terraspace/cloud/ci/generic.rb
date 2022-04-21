class Terraspace::Cloud::Ci
  class Generic
    def vars
      {
        build_system: "generic",
        host: ENV['TS_CI_HOST'] || ENV['TS_VCS_HOST'],
        full_repo: ENV['TS_CI_REPO'],
        branch_name: ENV['TS_CI_BRANCH'],
        # urls
        commit_url: ENV['TS_CI_COMMIT_URL'],
        branch_url: ENV['TS_CI_BRANCH_URL'],
        pr_url: ENV['TS_CI_PR_URL'],
        build_url: ENV['TS_CI_BUILD_URL'],
        # additional properties
        build_type: ENV['TS_CI_BUILD_TYPE'],
        pr_number: ENV['TS_CI_PR_NUMBER'],
        sha: ENV['TS_CI_SHA'],
        # additional properties
        commit_message: ENV['TS_CI_COMMIT_MESSAGE'],
        build_id: ENV['TS_CI_BUILD_ID'],
        build_number: ENV['TS_CI_BUILD_NUMBER'],
      }
    end
  end
end
