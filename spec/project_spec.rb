# frozen_string_literal: true

require 'spec_helper'

RSpec.describe YardiConvertTools::Project, type: :aruba do
  before(:all) { remove_test_files }
  after(:each) { remove_test_files }

  let(:project) { YardiConvertTools::Project.create_project(jira_ticket) }

  def jira_ticket
    'XYZ-1234'.freeze
  end

  def remove_test_files
    remove_test_dirs
  end

  def remove_test_dirs
    project_root_dir = YardiConvertTools::Project.project_root_dir(jira_ticket)
    project_subdirs = Dir.glob(File.join(project_root_dir, '*'))
    FileUtils.rmdir(project_subdirs) unless project_subdirs.empty?
    FileUtils.rmdir(project_root_dir) if Dir.exist?(project_root_dir)
  end

  context '.create_project' do
    it 'should create the project' do
      expect(project.root_dir).to be_an_existing_path
    end

    it 'should create the project in-work subfolder' do
      expect(project.in_work_dir).to be_an_existing_path
    end

    it 'should create the project completed subfolder' do
      expect(project.completed_dir).to be_an_existing_path
    end
  end

  context '.create_property' do
    it 'should create the property'
  end

  context '.create_properties' do
    it 'should create the properties'
  end

  context '.create_properties' do
    it 'should create the properties'
  end
end
