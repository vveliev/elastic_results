require 'cucumber/formatter/json'
require 'elastic_results'
require 'elastic_results/cucumber/reportable'

module ElasticResults
  module Cucumber
    class Formatter < ::Cucumber::Formatter::Json
      include Reportable

      alias_method :old_after_test_case, :after_test_case
      def after_test_case(test_case, result)
        old_after_test_case test_case, result

        feature_hash = @feature_hashes.last
        feature_hash[:elements].each do |scenario_hash|
          record_scenario feature_hash, scenario_hash
        end
      end

      def done
        ElasticResults.write_urls
      end
    end
  end
end
