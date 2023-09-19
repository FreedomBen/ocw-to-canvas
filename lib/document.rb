require_relative 'learning_resource_type'

class Document
  attr_accessor :uuid
  attr_reader :hash, :data_json, :filename, :course_id, :title, :description, :file_relative, :learning_resource_types, :resource_type

  def initialize(hash)
    @uuid = nil
    @hash = hash
    @data_json = hash['data_json']
    @filename = hash['filename']
    @course_id = hash['course_id']
    @title = hash['title']
    @description = hash['description']
    @file_relative = hash['file']
    @learning_resource_types = LearningResourceType.get_all(hash['learning_resource_types'])
    @resource_type = hash['resource_type']
  end

  def self.from_orig_json(hash)
    # make sure we have a document.  if not raise an error
    unless hash['data_json']['resource_type'] == 'Document'
      raise 'This is not a document'
    end

    Document.new({
      'orig_hash' => hash,
      'data_json' => hash['data_json'],
      'filename' => hash['filename'],
      'course_id' => hash['course_id'],
      'title' => hash['data_json']['title'],
      'description' => hash['data_json']['description'],
      'file_relative' => hash['data_json']['file'],
      'learning_resource_types' => hash['data_json']['learning_resource_types'],
      'resource_type' => hash['data_json']['resource_type']
    })
  end

  def to_h
    {
      uuid: @uuid,
      filename: @filename,
      course_id: @course_id,
      title: @title,
      description: @description,
      file_relative: @file_relative,
      learning_resource_types: @learning_resource_types,
      resource_type: @resource_type
    }
  end

  def to_json
    to_h.to_json
  end

  def self.from_json(json_hash)
    Document.new(json_hash)
  end
end
