#!/usr/bin/env ruby

# FROZEN_STRING_LITERAL: true

require 'json'
require 'ostruct'
require 'pathname'
require 'fileutils'

require_relative 'lib/course'
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

  Dir.chdir('/seconddrive/ocw-content-offline-live-production')

  content_maps_filenames = `find . -iname 'content_map.json'`.split("\n")
  #content_maps_filenames = `find /seconddrive/ocw-content-offline-live-production/courses/9-00sc-introduction-to-psychology-fall-2011 -iname 'content_map.json'`.split("\n")

  content_maps =
    content_maps_filenames
    .map { |filename| File.read(filename) }
    .map { |json| JSON.parse(json) }
    .each_with_index
    .map do |content_json, i|
      data_json_filename = content_maps_filenames[i].gsub('content_map.json', 'data.json')
      {
        'filename' => content_maps_filenames[i],
        'course_id' => filename_to_course_id(content_maps_filenames[i]),
        'content_map' => content_json,
        'data_json_filename' => data_json_filename,
        'data_json' => JSON.parse(File.read(data_json_filename)) # This is the top-level data.json file for the course
      }
    end

  content_map_uuid_to_file =
    content_maps.inject({}) do |acc, content_map|
      content_map['content_map'].each do |uuid, filename|
        acc[uuid] = filename
        acc[filename] = uuid
      end
      acc
    end

  data_json_filenames = `find . -iname 'data.json'`.split("\n")
  #data_json_filenames = `find /seconddrive/ocw-content-offline-live-production/courses/9-00sc-introduction-to-psychology-fall-2011 -iname 'data.json'`.split("\n")
  data_json_files =
    data_json_filenames
    .map { |filename| File.read(filename) }
    .map { |json| JSON.parse(json) }
    .each_with_index
    .map do |data_json, i|
      course_id = filename_to_course_id(data_json_filenames[i])
      uuid_filename = data_json_filenames[i].split(course_id).last
      {
        'filename' => data_json_filenames[i],
        'course_id' => course_id,
        'uuid' => content_map_uuid_to_file[uuid_filename],
        'data_json' => data_json
      }
    end

  # QA check that the data_json files filename matches the filename for that UUID in the content_map
  temp_thing = []
  data_json_files.each do |data_json_file|
    break unless content_map_uuid_to_file
    break unless data_json_file['uuid']
    break unless content_map_uuid_to_file[data_json_file['uuid']]

    cmutf = content_map_uuid_to_file[data_json_file['uuid']]
    #if data_json_file['filename'] && data_json_file['filename'].end_with?(cmutf)
    if data_json_file['filename']&.end_with?(cmutf)
      temp_thing << data_json_file['filename']
      #raise "Filename mismatch for UUID #{data_json_file['uuid']}: #{data_json_file['filename']} vs #{cmutf}"
    end
  end

  #data_json_resource_types =
  #  data_json_files
  #  .map { |data_item| data_item['data_json']['resource_type'] }
  #  .uniq

  img_djs = data_json_files.select { |data_item| data_item['data_json']['resource_type'] == 'Image' }
  doc_djs = data_json_files.select { |data_item| data_item['data_json']['resource_type'] == 'Document' }
  other_djs = data_json_files.select { |data_item| data_item['data_json']['resource_type'] == 'Other' }
  video_djs = data_json_files.select { |data_item| data_item['data_json']['resource_type'] == 'Video' }

  img_obj = img_djs.map { |data_item| Image.new(data_item) }
  doc_obj = doc_djs.map { |data_item| Document.new(data_item) }
  other_obj = img_djs.map { |data_item| Other.new(data_item) }
  video_obj = img_djs.map { |data_item| Video.new(data_item) }

  items = img_obj + doc_obj + other_obj + video_obj

  # QA check that we aren't losing items
  unless items.count == img_obj.count + doc_obj.count + other_obj.count + video_obj.count
    raise "We lost some items! #{items.count} != #{img_obj.count} + #{doc_obj.count} + #{other_obj.count} + #{video_obj.count}"
  end

  # Now construct the course objects
  # Use the content_map.json file for the course to get a list of all the data.json files,
  # and connect those with what we've parsed above using the relative_file attribute
  courses = content_maps.map do |content_map|
    Course.new(content_map['course_id'], content_map['content_map'], content_map['data_json'])
  end

  # Go through each course and populate them with their resources using UUID
  courses.each do |course|
    items.each do |item|
      course.add_item(item)
    end
  end

  #
  # At this point we have the list of courses built!
  # - We do have some filename collisions that make multiple courses fail when checking the filenames and UUIDs.
  # - Need to figure out how to namespace the UUIDs/filenames
  #

  # previous impl for video extraction
  #data_json_video_files =
  #  data_json_files
  #  .select { |data_item| data_item['data_json']['resource_type'] == 'Video' && !data_item['data_json']['captions_file'].nil? }
  #  .reject { |data_item| data_item['data_json']['archive_url'].nil? || data_item['data_json']['archive_url'].empty? }

  #require 'byebug'; debugger
end

main(ARGV)
