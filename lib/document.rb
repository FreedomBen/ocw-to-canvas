require_relative 'learning_resource_type'

class Document
  attr_accessor :uuid
  attr_reader :hash, :data_json, :filename, :course_id, :title, :description, :file_relative, :learning_resource_types, :resource_type

  def initialize(hash)
    # make sure we have a document.  if not raise an error
    unless hash['data_json']['resource_type'] == 'Document'
      raise 'This is not a document'
    end

    @uuid = nil
    @hash = hash
    @data_json = hash['data_json']
    @filename = hash['filename']
    @course_id = hash['course_id']
    @title = @data_json['title']
    @description = @data_json['description']
    @file_relative = @data_json['file']
    @learning_resource_types = LearningResourceType.get_all(@data_json['learning_resource_types'])
    @resource_type = @data_json['resource_type']
  end
end
