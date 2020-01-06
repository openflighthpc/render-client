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

require 'tempfile'
require 'tty-editor'

module RenderClient
  module Commands
    Template = Struct.new(:id) do
      include Concerns::HasTableRenderer

      SHOW_TABLE = [
        ['ID',      ->(t) { t.id }],
        ['Name',    ->(t) { t.name }],
        ['Type',    ->(t) { t.type }],
        ['Content', ->(t) { t.payload }]
      ]

      def self.method_missing(s, *a, &b)
        if respond_to_missing?(s) == :instance
          id = a.first
          rest = a[1..-1]
          new(id).send(s, *rest, &b)
        else
          super
        end
      end

      def self.respond_to_missing?(s)
        self.instance_methods.include?(s) ? :instance : super
      end

      attr_reader :name, :type

      def initialize(*a)
        super
        @name, @type = id.split('.', 2)
      end

      def show
        template = TemplateRecord.find(id).first
        puts render_table(SHOW_TABLE, template)
      end

      def create(path = nil)
        template = TemplateRecord.create(
          name: name,
          file_type: type,
          payload: path.nil? ? '' : File.read(File.expand_path(path, Dir.pwd))
        )
        puts render_table(SHOW_TABLE, template)
      end

      def update(path)
        abs_path = File.expand_path(path, Dir.pwd)
        template = TemplateRecord.new(id: id)
        template.mark_as_persisted!
        template.update(payload: File.read(abs_path))
        puts render_table(SHOW_TABLE, template)
      end

      def edit
        template = TemplateRecord.find(id).first.tap do |t|
          Tempfile.open(t.id) do |io|
            io.write(t.payload)
            io.rewind
            TTY::Editor.open(io.path)
            t.update(payload: io.read)
          end
        end
        puts render_table(SHOW_TABLE, template)
      end

      def delete
        TemplateRecord.new(id: id).destroy
      end
    end
  end
end

