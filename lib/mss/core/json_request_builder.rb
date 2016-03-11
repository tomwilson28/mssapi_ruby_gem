# Copyright 2011-2013 Amazon.com, Inc. or its affiliates. All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License"). You
# may not use this file except in compliance with the License. A copy of
# the License is located at
#
#
# or in the "license" file accompanying this file. This file is
# distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF
# ANY KIND, either express or implied. See the License for the specific
# language governing permissions and limitations under the License.

module MSS
  module Core

    # @api private
    class JSONRequestBuilder

      def initialize api, operation
        @x_amz_target = api[:target_prefix] + operation[:name]
        @content_type = "application/x-amz-json-#{api[:json_version] || 1.0}"
        @grammar = OptionGrammar.customize(operation[:inputs])
      end

      def populate_request request, options
        request.headers["content-type"] = @content_type
        request.headers["x-amz-target"] = @x_amz_target
        request.body = @grammar.to_json(options)
      end

    end

  end
end
