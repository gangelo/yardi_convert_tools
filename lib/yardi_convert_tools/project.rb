# frozen_string_literal: true

require 'fileutils'
require 'ostruct'
require 'pry'

module YardiConvertTools
  # Class for projects.
  class Project
    DEFAULT_ROOT_DIR = '/tmp'
    DEFAULT_DRY_DIR = '/dry'
    DEFAULT_LIVE_DIR = '/live'

    attr_reader :jira_ticket
    attr_reader :property_ids
    attr_reader :root_dir
    attr_reader :dry_dir
    attr_reader :live_dir
    attr_reader :property_files

    def initialize(jira_ticket, property_ids = [])
      project = Project.create(jira_ticket, property_ids)
      self.jira_ticket = project[:jira_ticket]
      self.property_ids = project[:property_ids]
      self.root_dir = project[:root_dir]
      self.dry_dir = project[:dry_dir]
      self.live_dir = project[:live_dir]
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
        dry_dir: project_subdirs[:dry_dir],
        live_dir: project_subdirs[:live_dir],
        property_files: property_files
      }
    end

    # The default root directory that all projects will be created under.
    def self.default_root_dir
      # TODO: Get this from config file
      DEFAULT_ROOT_DIR
    end

    # The default dry directory for the project.
    def self.default_dry_dir
      # TODO: Get this from config file
      DEFAULT_DRY_DIR
    end

    # The default live directory for the project.
    def self.default_live_dir
      # TODO: Get this from config file
      DEFAULT_LIVE_DIR
    end

    def self.project_root_dir(jira_ticket)
      project_root_dir_for(jira_ticket)
    end

    def self.project_dry_dir(jira_ticket)
      project_root_dir = project_root_dir_for(jira_ticket)
      File.join(project_root_dir, default_dry_dir)
    end

    def self.project_live_dir(jira_ticket)
      project_root_dir = project_root_dir_for(jira_ticket)
      File.join(project_root_dir, default_live_dir)
    end

    def self.normalize_jira_ticket(jira_ticket)
      jira_ticket.upcase
    end

    def self.project_root_dir_for(jira_ticket)
      jira_ticket = normalize_jira_ticket(jira_ticket)
      File.join(default_root_dir, jira_ticket)
    end

    def self.project_dry_dir_for(jira_ticket)
      project_root_dir = project_root_dir_for(jira_ticket)
      File.join(project_root_dir, default_dry_dir)
    end

    def self.project_live_dir_for(jira_ticket)
      project_root_dir = project_root_dir_for(jira_ticket)
      File.join(project_root_dir, default_live_dir)
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

      project_sub_dirs[:dry_dir] =
        File.join(project_root_dir, default_dry_dir)
      project_sub_dirs[:live_dir] =
        File.join(project_root_dir, default_live_dir)

      FileUtils.mkpath(project_sub_dirs[:dry_dir])
      FileUtils.mkpath(project_sub_dirs[:live_dir])

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
      file = File.join(project_dry_dir_for(jira_ticket),
                       property_dry_file_name_for(property_id))
      FileUtils.touch(file)
      file
    end

    def self.create_live_property_file(jira_ticket, property_id)
      file = File.join(project_live_dir_for(jira_ticket),
                       property_live_file_name_for(property_id))
      FileUtils.touch(file)
      file
    end

    def self.property_dry_file_name_for(property_id)
      "#{property_id}.dry.txt"
    end

    def self.property_live_file_name_for(property_id)
      "#{property_id}.live.txt"
    end

    private_class_method :normalize_jira_ticket
    private_class_method :project_root_dir_for
    private_class_method :expand_project_root_dir
    private_class_method :project_dry_dir_for
    private_class_method :project_live_dir_for
    private_class_method :create_root_dir
    private_class_method :create_sub_dirs
    private_class_method :create_property_files
    private_class_method :property_dry_file_name_for
    private_class_method :property_live_file_name_for

    private

    attr_writer :jira_ticket
    attr_writer :property_ids
    attr_writer :root_dir
    attr_writer :dry_dir
    attr_writer :live_dir
    attr_writer :property_files
  end
end
