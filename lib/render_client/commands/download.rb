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

require 'hashie'

module RenderClient
  module Commands
    class Download < Hashie::Dash
      def self.run!(*args, **kwargs)
        new(ids: args, **kwargs).run!
      end

      property :ids, default: []

      # NOTE: These properties map to the command line flags
      property :nodes
      property :nodes_in
      property :groups
      property :cluster
      property :output, default: Dir.pwd
      property :force

      def run!
        FileRecord.includes(:context, :template).where(**request_opts).each do |file|
          dir = case ctx = file.context
                when NodeRecord
                  "nodes/#{ctx.name}"
                when GroupRecord
                  "groups/#{ctx.name}"
                when ClusterRecord
                  'cluster'
                end
          path = File.join(output, dir, file.template.id)
          if !force && File.exists?(path)
            puts "Skipping: #{path}"
          else
            if force && File.exists?(path)
              puts "Forced:   #{path}"
            else
              puts "Download: #{path}"
            end
            FileUtils.mkdir_p File.dirname(path)
            File.write path, file.payload
          end
        end
      end

      def request_opts
        {}.tap do |h|
          h[:'node.ids'] = nodes          if nodes
          h[:'node.group-ids'] = nodes_in if nodes_in
          h[:'group.ids'] = groups        if groups
          h[:cluster] = 'true'            if cluster
          h[:ids] = ids.join(',')         unless ids.empty?
        end
      end
    end
  end
end

