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

task :setup do
  $: << File.expand_path('lib', __dir__)
  ENV['BUNDLE_GEMFILE'] ||= File.join(__dir__, 'Gemfile')

  require 'rubygems'
  require 'bundler/setup'

  # require 'active_support/core_ext/string'
  # require 'active_support/core_ext/module'
  # require 'active_support/core_ext/module/delegation'

  # require 'nodeattr_client/config'

  # if NodeattrClient::Config::Cache.debug?
  #   # Redirect stderr to suppress IRB redefinition
  #   old_stderr = $stderr
  #   $stderr = StringIO.new
  #   require 'pry'
  #   require 'pry-byebug'
  #   $stderr = old_stderr
  # end
end

task console: :setup do
  # require 'nodeattr_client/cli'
  binding.pry
end

