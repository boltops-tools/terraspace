class Terraspace::Cloud::Vcs
  class LocalGit < Base
    def vars
      if git_repo? && git_installed?
        provider_vars = vcs_class ? vcs_class.new(base_vars, git_url).vars : {}
        base_vars.merge(provider_vars).compact # remove items with nil values
      else
        { build_system: "manual" }
      end
    end

    def vcs_class
      case host
      when /github\.com/ then Github
      when /gitlab\.com/ then Gitlab
      when /bitbucket\.org/ then Bitbucket
      when /ssh\.dev\.azure\.com/ then Azure
      end
    end

    def base_vars
      {
        build_system: "manual",   # required
        host: host,
        full_repo: full_repo,
        branch_name: branch_name,
        sha: sha,
        dirty: dirty?,
        # commit_url: commit_url,  # provided by provider vars
        # branch_url: branch_url,  # provided by provider vars
      }
    end

    def host
      return nil unless File.exist?('.git')
      return nil if git_url.blank?
      uri = URI(git_url)
      "#{uri.scheme}://#{uri.host}"
    end

    def full_repo
      uri = URI(git_url)
      uri.path.sub(/^\//,'')
    end

    def dirty?
      out = git "status --porcelain"
      !out.blank?
    end

    # Works for
    #   git@github.com:    => https://github.com/
    #   git@bitbucket.org: => https://bitbucket.org/
    #   git@gitlab.com:    => https://gitlab.com/
    def git_url
      remotes = git("remote").strip.split("\n")
      remote_name = remotes.size == 1 ? remotes[0] : "origin"
      out = git "config --get remote.#{remote_name}.url"
      out.sub(/\.git/,'').sub(/^git@/,'https://').sub(/\.(.*):/,'.\1/')
    end

    def branch_name
      out = git "rev-parse --abbrev-ref HEAD"
      out unless out == "HEAD" # edge case: when branch has never been pushed
    end

    def sha
      out = git "rev-parse HEAD"
      out unless out == "HEAD" # edge case: when branch has never been pushed
    end

    def git(command)
      return unless git_installed?
      out = `git #{command}`
      unless $?.success?
        logger.debug "WARN Command Failed: git #{command}".color(:yellow)
      end
      out.strip
    end
    memoize :git

    def git_installed?
      system "type git > /dev/null 2>&1"
    end

    def git_repo?
      File.exist?('.git')
    end
  end
end
