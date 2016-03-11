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

$:.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

# Running a test of the eager_autoload!

require 'mss-sdk'

print "Autoloads under non-autoload modules get picked up: "
MSS.eager_autoload!
exit 1 unless MSS::Core.autoload?(:Client) == nil
puts "ok"
exit 0
