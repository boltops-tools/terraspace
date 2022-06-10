module Terraspace::Cloud::Api::Concern
  module Record
    def load_record(result)
      record = {}
      data = result['data']
      record['id'] = data['id']
      record.merge!(data['attributes'])
      record
    end

    def load_records(result)
      result['data'].map do |item|
        record = { id: item['id'] }
        record.merge(item['attributes'])
      end
    end
  end
end
