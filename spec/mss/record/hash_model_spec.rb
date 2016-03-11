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

require 'spec_helper'

module MSS
  module Record
    describe Model do

      it_should_behave_like("an mss record base class", MSS::Record::HashModel)

      it "should contain an assignable hash key" do
        model = Class.new(MSS::Record::HashModel)
        model.string_attr :hashname, :hash_key => true
        model.string_attr :foo
        model.hash_key.should == "hashname"
      end

    end
  end
end
