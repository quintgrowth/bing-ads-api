# -*- encoding : utf-8 -*-
module BingAdsApi

  class AdGroupPerformanceReportRequest < BingAdsApi::PerformanceReportRequest
    # Valid Columns for this report request
    COLUMNS = BingAdsApi::Config.instance.
      reporting_constants['account_performance_report']['columns']

    # Valid Filters for this report request
    FILTERS = BingAdsApi::Config.instance.
      reporting_constants['account_performance_report']['filter']

    def initialize(attributes={})
      super(attributes)
    end

    def to_hash(keys = :underscore)
      hash = super(keys)

      binding.pry
      hash[get_attribute_key('columns', keys)] =
        columns_to_hash(COLUMNS, columns, keys)
      hash[get_attribute_key('filter', keys)] =
        filter_to_hash(FILTERS, keys)
      hash[get_attribute_key('scope', keys)] = scope_to_hash(keys)
      hash["@xsi:type"] = type_attribute_for_soap
      return hash
    end

    private

    def scope_to_hash(keys_case=:underscore)
      return { get_attribute_key('account_ids', keys_case) =>
                 {"ins0:long" => object_to_hash(scope[:account_ids], keys_case)} }
    end

    def type_attribute_for_soap
      return BingAdsApi::ClientProxy::NAMESPACE.to_s + ":" +
        BingAdsApi::Config.instance.
          reporting_constants['account_performance_report']['type']
    end

  end
end