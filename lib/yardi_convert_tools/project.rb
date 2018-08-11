# frozen_string_literal: true

require 'fileutils'
require 'ostruct'
require 'pry'

module YardiConvertTools
  # Class for projects.
  class Project
    DEFAULT_ROOT_DIR = '/tmp'
    DEFAULT_TODO_DIR = '/todo'
    DEFAULT_IN_WORK_DIR = '/in-work'
    DEFAULT_COMPLETED_DIR = '/completed'

    attr_reader :jira_ticket
    attr_reader :property_ids
    attr_reader :root_dir
    attr_reader :todo_dir
    attr_reader :in_work_dir
    attr_reader :completed_dir
    attr_reader :property_files

    def initialize(jira_ticket, property_ids = [])
      project = Project.create(jira_ticket, property_ids)
      self.jira_ticket = project[:jira_ticket]
      self.property_ids = project[:property_ids]
      self.root_dir = project[:root_dir]
      self.todo_dir = project[:todo_dir]
      self.in_work_dir = project[:in_work_dir]
      self.completed_dir = project[:completed_dir]
      self.property_files = project[:property_files]
    end

    # TODO: Load an existing project
    def self.load(jira_ticket); end

    def self.create(jira_ticket, property_ids = [])
      project_root_dir = create_root_dir(jira_ticket)
      project_subdirs = create_sub_dirs(project_root_dir)
      property_files = create_property_files(jira_ticket, property_ids)
      {
        jira_ticket: normalize_jira_ticket(jira_ticket),
        property_ids: property_ids,
        root_dir: project_root_dir,
        todo_dir: project_subdirs[:todo_dir],
        in_work_dir: project_subdirs[:in_work_dir],
        completed_dir: project_subdirs[:completed_dir],
        property_files: property_files
      }
    end

    # The default root directory that all projects will be created under.
    def self.default_root_dir
      # TODO: Get this from config file
      DEFAULT_ROOT_DIR
    end

    # The default todo directory for the project.
    def self.default_todo_dir
      # TODO: Get this from config file
      DEFAULT_TODO_DIR
    end

    # The default in-work directory for the project.
    def self.default_in_work_dir
      # TODO: Get this from config file
      DEFAULT_IN_WORK_DIR
    end

    # The default completed directory for the project.
    def self.default_completed_dir
      # TODO: Get this from config file
      DEFAULT_COMPLETED_DIR
    end

    def self.project_root_dir(jira_ticket)
      project_root_dir_for(jira_ticket)
    end

    def self.project_todo_dir(jira_ticket)
      project_root_dir = project_root_dir_for(jira_ticket)
      File.join(project_root_dir, default_todo_dir)
    end

    def self.project_in_work_dir(jira_ticket)
      project_root_dir = project_root_dir_for(jira_ticket)
      File.join(project_root_dir, default_in_work_dir)
    end

    def self.project_completed_dir(jira_ticket)
      project_root_dir = project_root_dir_for(jira_ticket)
      File.join(project_root_dir, default_completed_dir)
    end

    def self.normalize_jira_ticket(jira_ticket)
      jira_ticket.upcase
    end

    def self.project_root_dir_for(jira_ticket)
      jira_ticket = normalize_jira_ticket(jira_ticket)
      File.join(default_root_dir, jira_ticket)
    end

    def self.project_todo_dir_for(jira_ticket)
      project_root_dir = project_root_dir_for(jira_ticket)
      File.join(project_root_dir, default_todo_dir)
    end

    def self.project_in_work_dir_for(jira_ticket)
      project_root_dir = project_root_dir_for(jira_ticket)
      File.join(project_root_dir, default_in_work_dir)
    end

    def self.project_completed_dir_for(jira_ticket)
      project_root_dir = project_root_dir_for(jira_ticket)
      File.join(project_root_dir, default_completed_dir)
    end

    # Expands any ~/whatever to /whatever
    def self.expand_project_root_dir(project_root_dir)
      File.expand_path(project_root_dir)
    end

    def self.create_root_dir(jira_ticket)
      project_root_dir = project_root_dir_for(jira_ticket)
      project_root_dir = expand_project_root_dir(project_root_dir)
      FileUtils.mkpath(project_root_dir)
      project_root_dir
    end

    def self.create_sub_dirs(project_root_dir)
      project_sub_dirs = {}

      project_sub_dirs[:todo_dir] =
        File.join(project_root_dir, default_todo_dir)
      project_sub_dirs[:in_work_dir] =
        File.join(project_root_dir, default_in_work_dir)
      project_sub_dirs[:completed_dir] =
        File.join(project_root_dir, default_completed_dir)

      FileUtils.mkpath(project_sub_dirs[:todo_dir])
      FileUtils.mkpath(project_sub_dirs[:in_work_dir])
      FileUtils.mkpath(project_sub_dirs[:completed_dir])

      project_sub_dirs
    end

    def self.create_property_files(jira_ticket, property_ids)
      property_files = { dry_files: [], live_files: [] }
      property_ids.each do |property_id|
        dry_file = create_dry_property_file(jira_ticket, property_id)
        live_file = create_live_property_file(jira_ticket, property_id)
        property_files[:dry_files] << dry_file
        property_files[:live_files] << live_file
      end
      property_files
    end

    def self.create_dry_property_file(jira_ticket, property_id)
      file = File.join(project_todo_dir_for(jira_ticket),
                       property_dry_file_name_for(property_id))
      FileUtils.touch(file)
      file
    end

    def self.create_live_property_file(jira_ticket, property_id)
      file = File.join(project_todo_dir_for(jira_ticket),
                       property_live_file_name_for(property_id))
      FileUtils.touch(file)
      file
    end

    def self.property_dry_file_name_for(property_id)
      "dry.#{property_id}.txt"
    end

    def self.property_live_file_name_for(property_id)
      "live.#{property_id}.txt"
    end

    private_class_method :normalize_jira_ticket
    private_class_method :project_root_dir_for
    private_class_method :expand_project_root_dir
    private_class_method :project_todo_dir_for
    private_class_method :project_in_work_dir_for
    private_class_method :create_root_dir
    private_class_method :create_sub_dirs
    private_class_method :create_property_files
    private_class_method :property_dry_file_name_for
    private_class_method :property_live_file_name_for

    private

    attr_writer :jira_ticket
    attr_writer :property_ids
    attr_writer :root_dir
    attr_writer :todo_dir
    attr_writer :in_work_dir
    attr_writer :completed_dir
    attr_writer :property_files
  end
end
