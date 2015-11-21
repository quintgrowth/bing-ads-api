# -*- encoding : utf-8 -*-

module BingAdsApi
	
	##
	# Public : Defines the base object for all report requests.
	# Do not instantiate this object. Instead, you may instantiate one 
	# of the following report request objects which derives from this object to request a report.
	# 
	# Reference: http://msdn.microsoft.com/en-us/library/bing-ads-reporting-bing-ads-reportrequest.aspx
	#
	# Author:: jlopezn@neonline.cl 
	# 
	# === Usage
	#   
	#   request = BingAdsApi::AccountPerformanceReportRequest.new(
	#     :format   => :xml,
	#     :language => :english,
	#     :report_name => "Me report",
	#     :aggregation => :hourly,
	#     :columns => [:account_name, :account_number, :time_period],
	#     # The filter is specified as a hash
	#     :filter => {
	#       :ad_distribution => :search, 
	#       :device_os => :android,
	#       :device_type => :tablet,
	#       :status => :submited },
	#     :scope => { 
	#       :account_ids => [123456, 234567],
	#       :campaigns => [<BingAdsApi::CampaignReportScope>] },
	#     # predefined date
	#     :time => :this_week)
	#   
	#   request2 = BingAdsApi::AccountPerformanceReportRequest.new(
	#     :format   => :csv,
	#     :language => :french,
	#     :report_name => "Me report",
	#     :aggregation => :daily,
	#     :columns => [:account_name, :account_number, :time_period],
	#     # no filter is specified
	#     :scope => { 
	#       :account_ids => [123456, 234567],
	#       :campaigns => [<BingAdsApi::CampaignReportScope>] },
	#     # Custom date range
	#     :time => {
	#       :custom_date_range_start => {:day => 1, :month => 12, :year => 2013},
	#       :custom_date_range_end   => {:day => 12, :month => 12, :year => 2013} }
	#     )
	class AccountPerformanceReportRequest < BingAdsApi::PerformanceReportRequest
		
		# Valid Columns for this report request 
		COLUMNS = BingAdsApi::Config.instance.
			reporting_constants['account_performance_report']['columns']
		
		# Valid Filters for this report request 
		FILTERS = BingAdsApi::Config.instance.
			reporting_constants['account_performance_report']['filter']
		
		
		# Public : Constructor. Adds a validations for the columns, filter 
		# and scope attributes 
		# 
		# Author:: jlopezn@neonline.cl 
		# 
		# === Parameters
		# attributes - Hash with the report request attributes
		#
		# === Example
		#   
		#   request = BingAdsApi::AccountPerformanceReportRequest.new(
		#     :format   => :xml,
		#     :language => :english,
		#     :report_name => "Me report",
		#     :aggregation => :hourly,
		#     :columns => [:account_name, :account_number, :time_period],
		#     # The filter is specified as a hash
		#     :filter => {
		#       :ad_distribution => :search, 
		#       :device_os => :android,
		#       :device_type => :tablet,
		#       :status => :submited },
		#     :scope => { 
		#       :account_ids => [123456, 234567],
		#       :campaigns => [<BingAdsApi::CampaignReportScope>] },
		#     # predefined date
		#     :time => :this_week)
		#   
		#   request2 = BingAdsApi::AccountPerformanceReportRequest.new(
		#     :format   => :csv,
		#     :language => :french,
		#     :report_name => "Me report",
		#     :aggregation => :daily,
		#     :columns => [:account_name, :account_number, :time_period],
		#     # no filter is specified
		#     :scope => { 
		#       :account_ids => [123456, 234567],
		#       :campaigns => [<BingAdsApi::CampaignReportScope>] },
		#     # Custom date range
		#     :time => {
		#       :custom_date_range_start => {:day => 1, :month => 12, :year => 2013},
		#       :custom_date_range_end   => {:day => 12, :month => 12, :year => 2013} }
		#     )
		def initialize(attributes={})
			raise "Invalid columns" if !valid_columns(COLUMNS, attributes[:columns])
			raise "Invalid filters" if !valid_filter(FILTERS, attributes[:filter])
			raise "Invalid scope" if !valid_scope(attributes[:scope])
			super(attributes)
		end

		# Public:: Returns the object as a Hash valid for SOAP requests 
		# 
		# Author:: jlopezn@neonline.cl 
		# 
		# === Parameters
		# * +keys_case+ - case for the hashes keys: underscore or camelcase
		# 
		# Returns:: Hash
		def to_hash(keys = :underscore)
			hash = super(keys)
      hash[get_attribute_key('columns', keys)] =
        columns_to_hash(COLUMNS, columns, keys)
      filter_hash = filter_to_hash(FILTERS, filter, keys)
      hash[get_attribute_key('filter', keys)] = filter_hash if filter_hash.present?
      scope_hash = scope_to_hash(keys)
      hash[get_attribute_key('scope', keys)] = scope_hash
      hash['@xsi:type'] = type_attribute_for_soap
      hash
		end
		
		private
			

			
			# Internal:: Validates the scope attribute given in the constructor 
			# 
			# Author:: jlopezn@neonline.cl 
			# 
			# === Parameters
			# * +scope+ - value for the 'scope' key in the has initializer
			# 
			# Returns:: true if the scope specification is valid. Raises Exception otherwise
			# 
			# Raises:: Exception if the scope is not valid
			def valid_scope(scope)
				#raise Exception.new("Invalid scope: no account_ids key") if !scope.key?(:account_ids)
				return true
			end
			
			
			# Internal:: Returns the scope attribute as a hash for the SOAP request 
			# 
			# Author:: jlopezn@neonline.cl 
			# 
			# === Parameters
			# * +keys_case+ - case for the hash: underscore or camelcase
			# 
			# Returns:: Hash
			def scope_to_hash(keys_case=:underscore)
				return {} unless scope.present?
      	scope_hash = {}
      	account_ids_scope = object_to_hash(scope[:account_ids], keys_case)
      	scope_hash[get_attribute_key('account_ids', keys_case)] = {'ins0:long' => account_ids_scope} if account_ids_scope.present?
      	scope_hash
			end
			
			
			# Internal:: Returns a string with type attribute for the ReportRequest SOAP tag 
			# 
			# Author:: jlopezn@neonline.cl 
			# 
			# Returns:: "v9:AccountPerformanceReportRequest"
			def type_attribute_for_soap
				return BingAdsApi::ClientProxy::NAMESPACE.to_s + ":" + 
					BingAdsApi::Config.instance.
						reporting_constants['account_performance_report']['type']
			end

	end
	
end