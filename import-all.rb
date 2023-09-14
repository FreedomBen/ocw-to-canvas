#!/usr/bin/env ruby

# FROZEN_STRING_LITERAL: true

require 'json'
require 'ostruct'
require 'pathname'
require 'fileutils'

require_relative 'lib/ocw_course'
require_relative 'lib/document'
require_relative 'lib/other'
require_relative 'lib/video'
require_relative 'lib/image'

OCW_CONTENT_MIRROR_DIR = '/seconddrive/ocw-content-offline-live-production'
STATE_FILES_DIR = '/seconddrive/ocw-content-offline-live-production-state-files'

def data_item_to_video(data_item)
  OpenStruct.new(
    filename: data_item['filename'],
    course_id: data_item['course_id'],
    video: OpenStruct.new(
      video_id: data_json['youtube_key'],
      title: data_json['title'],
      description: data_json['description'],
      archive_url: data_json['archive_url'],
      captions_file: data_json['captions_file'],
      transcript_file: data_json['transcript_file']
    )
  )
end

def download_video(video)
  video.archive_url
end

def filename_to_course_id(filename)
  # Extract the directory right after "courses" from the path
  path = Pathname.new(filename)
  courses_index = path.each_filename.to_a.index('courses')

  course_name = path.each_filename.to_a[courses_index + 1] if courses_index

  course_name
end

def process_video(video)
  # Processing goes as follows:
  # Create the course directory if needed

end

def main(args)
  #FileUtils.mkdir_p(STATE_FILES_DIR)

  #Dir.chdir('/seconddrive/ocw-content-offline-live-production')

  #content_maps_filenames = `find . -iname 'content_map.json'`.split("\n")

  #content_maps =
  #  content_maps_filenames
  #  .map { |filename| File.read(filename) }
  #  .map { |json| JSON.parse(json) }
  #  .each_with_index
  #  .map do |content_json, i|
  #    {
  #      'filename' => content_maps_filenames[i],
  #      'course_id' => filename_to_course_id(content_maps_filenames[i]),
  #      'content_map' => content_json
  #    }
  #  end

  #data_json_filenames = `find . -iname 'data.json'`.split("\n")
  data_json_filenames = `find /seconddrive/ocw-content-offline-live-production/courses/9-00sc-introduction-to-psychology-fall-2011 -iname 'data.json'`.split("\n")
  data_json_files =
    data_json_filenames
    .map { |filename| File.read(filename) }
    .map { |json| JSON.parse(json) }
    .each_with_index
    .map do |data_json, i|
      {
        'filename' => data_json_filenames[i],
        'course_id' => filename_to_course_id(data_json_filenames[i]),
        'data_json' => data_json
      }
    end

  data_json_resource_types =
    data_json_files
    .map { |data_item| data_item['data_json']['resource_type'] }
    .uniq

  img_djs = data_json_files.select { |data_item| data_item['data_json']['resource_type'] == 'Image' }
  other_djs = data_json_files.select { |data_item| data_item['data_json']['resource_type'] == 'Other' }
  doc_djs = data_json_files.select { |data_item| data_item['data_json']['resource_type'] == 'Document' }
  video_djs = data_json_files.select { |data_item| data_item['data_json']['resource_type'] == 'Video' }

  doc_obj = doc_djs.map { |data_item| Document.new(data_item) }
  img_obj = img_djs.map { |data_item| Image.new(data_item) }
  other_obj = img_djs.map { |data_item| Other.new(data_item) }
  video_obj = img_djs.map { |data_item| Video.new(data_item) }

  require 'byebug'; debugger

  # Now construct the course objects

  # previous impl for video extraction
  data_json_video_files =
    data_json_files
    .select { |data_item| data_item['data_json']['resource_type'] == 'Video' && !data_item['data_json']['captions_file'].nil? }
    .reject { |data_item| data_item['data_json']['archive_url'].nil? || data_item['data_json']['archive_url'].empty? }

  require 'byebug'; debugger
end

main(ARGV)
