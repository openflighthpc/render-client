# frozen_string_literal: true

#==============================================================================
# Copyright (C) 2020-present Alces Flight Ltd.
#
# This file is part of Render Client.
#
# This program and the accompanying materials are made available under
# the terms of the Eclipse Public License 2.0 which is available at
# <https://www.eclipse.org/legal/epl-2.0>, or alternative license
# terms made available by Alces Flight Ltd - please direct inquiries
# about licensing to licensing@alces-flight.com.
#
# Render Client is distributed in the hope that it will be useful, but
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, EITHER EXPRESS OR
# IMPLIED INCLUDING, WITHOUT LIMITATION, ANY WARRANTIES OR CONDITIONS
# OF TITLE, NON-INFRINGEMENT, MERCHANTABILITY OR FITNESS FOR A
# PARTICULAR PURPOSE. See the Eclipse Public License 2.0 for more
# details.
#
# You should have received a copy of the Eclipse Public License 2.0
# along with Render Client. If not, see:
#
#  https://opensource.org/licenses/EPL-2.0
#
# For more information on Render Client, please visit:
# https://github.com/openflighthpc/render-client
#===============================================================================

require 'json_api_client'

module RenderClient
  class BaseRecord < JsonApiClient::Resource
    def self.inherited(klass)
      resolve_custom_type klass.resource_name, klass
    end

    def self.resource_name
      @table_name ||= self.to_s.demodulize.chomp('Record').downcase.pluralize
    end

    self.site = Config::Cache.base_url
    self.connection.faraday.authorization :Bearer, Config::Cache.jwt_token
  end

  class ClusterRecord < BaseRecord
  end

  class NodeRecord < BaseRecord
    property :name
  end

  class GroupRecord < BaseRecord
    property :name
  end

  class TemplateRecord < BaseRecord
    property :name
    property :file_type
    property :payload
  end

  class FileRecord < BaseRecord
    property :payload
  end
end

