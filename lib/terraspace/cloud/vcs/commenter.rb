class Terraspace::Cloud::Vcs
  module Commenter
    extend Memoist

    # record is plan or update
    def pr_comment(record, cost)
      return unless able_to_comment?

      resp = cloud_comment.get(record, cost)
      body = resp['data']['attributes']['body'] if resp
      if body
        vcs.comment(body)
      else
        logger.info "WARN: Unable to post a PR comment"
      end
    end

    def cloud_comment
      Terraspace::Cloud::Comment.new(@options.merge(stack: @mod.name, kind: kind))
    end
    memoize :cloud_comment

    def vcs
      # IE: TerraspaceVcsGithub::Interface.new
      Terraspace::Cloud::Vcs.detect(full_repo: vcs_vars[:full_repo], pr_number: vcs_vars[:pr_number])
    end
    memoize :vcs

    #
    # full_repo       # env or .git * min required for pr url
    # host            # env or .git * min required for pr url
    # branch_name     # env or .git
    # sha             # env or .git
    # dirty           # env or .git
    # pr_number       # env         * min required for pr url
    #
    # commit_message  # env
    # build_system    # env
    # build_id        # env
    # build_number    # env
    # build_type      # env
    #
    # build_url
    # commit_url
    # branch_url
    # pr_url
    #
    def vcs_vars
      return {} unless Terraspace.cloud?
      ci_env = CiEnv.new
      local_git = LocalGit.new
      local_env = LocalEnv.new
      vars = local_git.vars.merge(ci_env.vars).merge(local_env.vars)
      finalize_vars(local_git, vars)
    end
    memoize :vcs_vars

    # finalize branch_url since info is set from multiple layers
    def finalize_vars(local_git, vars)
      if local_git.vcs_class # IE: LocalGit::Github
        vars[:branch_url] ||= local_git.vcs_class.new(vars).branch_url # IE: LocalGit::Github#branch_url
      end
      vars
    end

    def able_to_comment?
      !!(vcs && vcs_vars[:full_repo] && vcs_vars[:pr_number])
    end

    def kind
      Terraspace.is_destroy? ? "destroy" : "apply"
    end
  end
end
