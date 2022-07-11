module Terraspace::Cloud
  class Comment < Base
    def get(record, cost)
      return unless Terraspace.cloud?

      params = {}
      params[:record_id] = record['data']['id']
      params[:cost_id] = cost['data']['id'] if cost

      sleep 1 # delay a second since job is queued
      resp = nil
      Timeout::timeout(20) do
        loop do
          resp = api.get_comment(params)
          break if resp['data']['attributes']['status'] == 'completed'
          sleep 2
        end
      end
      resp
    rescue Timeout::Error
      # nil
    end

    def cani?(exit_on_error: true)
      api.create_cost(cani: 1, exit_on_error: exit_on_error)
    end
  end
end
