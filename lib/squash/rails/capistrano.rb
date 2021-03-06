# Copyright 2012 Square Inc.
#
#    Licensed under the Apache License, Version 2.0 (the "License");
#    you may not use this file except in compliance with the License.
#    You may obtain a copy of the License at
#
#        http://www.apache.org/licenses/LICENSE-2.0
#
#    Unless required by applicable law or agreed to in writing, software
#    distributed under the License is distributed on an "AS IS" BASIS,
#    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#    See the License for the specific language governing permissions and
#    limitations under the License.

# Capistrano tasks for Rails apps using Squash.

Capistrano::Configuration.instance.load do
  namespace :squash do
    desc "Notifies Squash of a new deploy."
    task :notify, :roles => :web, :only => {:primary => true}, :except => {:no_release => true} do
      rails_env = fetch(:rails_env, 'production')
      run "cd #{current_path} && env RAILS_ENV=#{rails_env} #{fetch(:bundle_cmd, "bundle")} exec rake squash:notify REVISION=#{real_revision} DEPLOY_ENV=#{rails_env}"
    end
  end

  after 'deploy:restart', 'squash:notify'
  after 'deploy:start', 'squash:notify'
end
