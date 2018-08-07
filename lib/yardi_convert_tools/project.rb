require 'fileutils'
require 'pry'

module YardiConvertTools
  module Project
    DEFAULT_ROOT_DIR = '~/Downloads'.freeze

    def self.create_project(jira_ticket)
      jira_ticket.upcase!
      # TODO: Create a folder for the ticket
      # TODO: Create sub-folders for the ticket
      project_root_dir = merge_project_root_dir(jira_ticket)
      project_root_dir = expand_project_root_dir(project_root_dir)
      FileUtils.mkpath(project_root_dir)
    rescue => e
      puts e.message
    end

    # TODO: Get this from config file
    def self.project_root_dir
      DEFAULT_ROOT_DIR
    end

    def self.merge_project_root_dir(jira_ticket)
      File.join(DEFAULT_ROOT_DIR, jira_ticket)
    end

    def self.expand_project_root_dir(project_root_dir)
      File.expand_path(project_root_dir)
    end

    private_class_method :merge_project_root_dir
    private_class_method :expand_project_root_dir
  end
end
