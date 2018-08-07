require 'spec_helper'

RSpec.describe YardiConvertTools::Project, :type => :aruba do
  let(:downloads_dir) { %w{ ~/Downloads } }
  let(:jira_ticket) { %w{ xx-1234 } }
  let(:project_dir) { File.join(downloads_dir, jira_ticket) }

  context '.create_project' do
    it 'should create the project' do
      YardiConvertTools::Project.create_project(jira_ticket)
      expect(project_dir).to be_an_existing_path
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
