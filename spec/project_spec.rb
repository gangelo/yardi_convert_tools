# frozen_string_literal: true

require 'spec_helper'

RSpec.describe YardiConvertTools::Project, type: :aruba do
  before(:all) { remove_test_files }
  after(:each) { remove_test_files }

  let(:project) { YardiConvertTools::Project.new(jira_ticket, property_ids) }

  def jira_ticket
    'XYZ-1234'.freeze
  end

  def property_ids
    %w{ 0 1 2 3 4 5 6 7 8 9 }
  end

  def remove_test_files
    remove_test_dirs
  end

  def remove_test_dirs
    project_root_dir = YardiConvertTools::Project.project_root_dir(jira_ticket)
    project_subdirs = Dir.glob(File.join(project_root_dir, '*'))
    project_files = Dir.glob(File.join(project_root_dir, '**/*.{dry.txt,live.txt}'))
    FileUtils.rm(project_files) unless project_files.empty?
    FileUtils.rmdir(project_subdirs) unless project_subdirs.empty?
    FileUtils.rmdir(project_root_dir) if Dir.exist?(project_root_dir)
  end

  context 'attributes' do
    context '#jira_ticket' do
      it 'should be the right jira ticket' do
        expect(project.jira_ticket).to eq(jira_ticket)
      end
    end

    context '#property_ids' do
      it 'should have the right property ids' do
        expect(project.property_ids).to match_array(property_ids)
      end
    end

    context '#root_dir' do
      it 'should have the right root directory' do
        expect(project.root_dir).to eq(File.join('/tmp', "#{jira_ticket}"))
      end
    end

    context '#dry_dir' do
      it 'should have the right dry run directory' do
        expect(project.dry_dir).to eq(File.join('/tmp', "#{jira_ticket}/dry"))
      end
    end

    context '#live_dir' do
      it 'should have the right live run directory' do
        expect(project.live_dir).to eq(File.join('/tmp', "#{jira_ticket}/live"))
      end
    end

    context '#property_files' do
      it 'should have the right dry run files' do
        (0..9).each do |index|
          file = project.property_files[:dry_files][index]
          expect(file).to eq("/tmp/#{jira_ticket}/dry/#{index}.dry.txt")
        end
      end

      it 'should have the right live run files' do
        (0..9).each do |index|
          file = project.property_files[:live_files][index]
          expect(file).to eq("/tmp/#{jira_ticket}/live/#{index}.live.txt")
        end
      end
    end
  end

  context '#new' do
    it 'should create the project root directory' do
      expect(project.root_dir).to be_an_existing_path
    end

    it 'should create the project dry subfolder' do
      expect(project.dry_dir).to be_an_existing_path
    end

    it 'should create the project live subfolder' do
      expect(project.live_dir).to be_an_existing_path
    end

    it 'should create the dry project files' do
      project.property_files[:dry_files].each do |dry_file|
        expect(dry_file).to be_an_existing_file
      end
    end

    it 'should create the live project files' do
      project.property_files[:live_files].each do |live_file|
        expect(live_file).to be_an_existing_file
      end
    end
  end
end
