# frozen_string_literal: true

require 'fileutils'
require 'ostruct'
require 'pry'

module YardiConvertTools
  # Helpers to handle the project.
  module Project
    DEFAULT_ROOT_DIR = '/tmp'
    DEFAULT_IN_WORK_DIR = '/in-work'
    DEFAULT_COMPLETED_DIR = '/completed'

    def self.create_project(jira_ticket)
      project_root_dir = create_project_root_dir(jira_ticket)
      raise StandardError, 'Unable to create project root directory'\
        unless project_root_dir
      project_subdirs = create_project_sub_dirs(project_root_dir)
      create_project_struct(jira_ticket, project_root_dir, project_subdirs)
    end

    # TODO: Get this from config file
    def self.root_dir
      DEFAULT_ROOT_DIR
    end

    def self.project_root_dir(jira_ticket)
      make_project_root_dir(jira_ticket)
    end

    def self.project_in_work_dir(jira_ticket)
      project_root_dir = make_project_root_dir(jira_ticket)
      File.join(project_root_dir, DEFAULT_IN_WORK_DIR)
    end

    def self.project_completed_dir(jira_ticket)
      project_root_dir = make_project_root_dir(jira_ticket)
      File.join(project_root_dir, DEFAULT_COMPLETED_DIR)
    end

    def self.create_project_struct(jira_ticket, project_root_dir, project_subdirs)
      project = OpenStruct.new
      project.jira_ticket = normalize_jira_ticket(jira_ticket)
      project.root_dir = project_root_dir
      project.in_work_dir = project_subdirs[:in_work_dir]
      project.completed_dir = project_subdirs[:completed_dir]
      project
    end

    def self.normalize_jira_ticket(jira_ticket)
      jira_ticket.upcase
    end

    def self.make_project_root_dir(jira_ticket)
      jira_ticket = normalize_jira_ticket(jira_ticket)
      File.join(DEFAULT_ROOT_DIR, jira_ticket)
    end

    def self.expand_project_root_dir(project_root_dir)
      File.expand_path(project_root_dir)
    end

    def self.create_project_root_dir(jira_ticket)
      project_root_dir = make_project_root_dir(jira_ticket)
      project_root_dir = expand_project_root_dir(project_root_dir)
      FileUtils.mkpath(project_root_dir)
      project_root_dir
    end

    def self.create_project_sub_dirs(project_root_dir)
      project_sub_dirs = {}

      project_sub_dirs[:in_work_dir] =
        File.join(project_root_dir, DEFAULT_IN_WORK_DIR)
      project_sub_dirs[:completed_dir] =
        File.join(project_root_dir, DEFAULT_COMPLETED_DIR)

      FileUtils.mkpath(project_sub_dirs[:in_work_dir])
      FileUtils.mkpath(project_sub_dirs[:completed_dir])

      project_sub_dirs
    end

    private_class_method :create_project_struct
    private_class_method :normalize_jira_ticket
    private_class_method :make_project_root_dir
    private_class_method :expand_project_root_dir
    private_class_method :create_project_root_dir
    private_class_method :create_project_sub_dirs
  end
end
