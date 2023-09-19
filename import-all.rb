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

def save_courses_to_file(courses, filename)
  File.write(filename, Course.courses_to_json(courses))
end

def restore_courses_from_file(filename)
  JSON.parse(File.read(filename)).map { |json| Course.from_json(json) }
end

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
        course_id = content_map['course_id']
        acc[course_id] ||= {}
        acc[course_id][uuid] = filename
        acc[course_id][filename] = uuid
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
        'uuid' => content_map_uuid_to_file[course_id][uuid_filename],
        'data_json' => data_json
      }
    end

  # TODO: about 5% of them are missing.  Investigate if this is a problem and why it's happening
  # # Ensure that all items have a UUID
  # count = 0
  # data_json_files.each do |data_json_file|
  #   count += 1 unless data_json_file['uuid']
  #   #raise "Missing UUID for #{data_json_file['filename']}" unless data_json_file['uuid']
  # end
  # if count != data_json_files.count
  #   raise "Missing UUID for #{count} of #{data_json_files.count} files (#{count.to_f / data_json_files.count * 100.0}%)"
  # end

  # # QA check that the data_json files filename matches the filename for that UUID in the content_map
  # temp_thing = []
  # data_json_files.each do |data_json_file|
  #   break unless content_map_uuid_to_file
  #   break unless data_json_file['uuid']
  #   break unless content_map_uuid_to_file[data_json_file['uuid']]

  #   cmutf = content_map_uuid_to_file[data_json_file['uuid']]
  #   #if data_json_file['filename'] && data_json_file['filename'].end_with?(cmutf)
  #   if data_json_file['filename']&.end_with?(cmutf)
  #     temp_thing << data_json_file['filename']
  #     #raise "Filename mismatch for UUID #{data_json_file['uuid']}: #{data_json_file['filename']} vs #{cmutf}"
  #   end
  # end

  #data_json_resource_types =
  #  data_json_files
  #  .map { |data_item| data_item['data_json']['resource_type'] }
  #  .uniq

  img_djs = data_json_files.select { |data_item| data_item['data_json']['resource_type'] == 'Image' }
  doc_djs = data_json_files.select { |data_item| data_item['data_json']['resource_type'] == 'Document' }
  other_djs = data_json_files.select { |data_item| data_item['data_json']['resource_type'] == 'Other' }
  video_djs = data_json_files.select { |data_item| data_item['data_json']['resource_type'] == 'Video' }

  img_obj = img_djs.map { |data_item| Image.from_orig_json(data_item) }
  doc_obj = doc_djs.map { |data_item| Document.from_orig_json(data_item) }
  other_obj = other_djs.map { |data_item| Other.from_orig_json(data_item) }
  video_obj = video_djs.map { |data_item| Video.from_orig_json(data_item) }

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

  # Build a hash of course_id => course object for fast lookups
  course_hash = courses.inject({}) { |acc, course| acc[course.course_id] = course; acc }

  # Go through each course and populate them with their resources using UUID
  items.each do |item|
    # Ensure that every item has a course and that the course exists
    raise "Item #{item.title} has no course!" unless item.course_id
    raise "Course #{item.course_id} does not exist!" unless course_hash[item.course_id]

    # Ensure that the UUID for the item exists in the content_map for the course
    # Allow if the uuid is nil, since some items don't have UUIDs, but after investigation
    # if the missing UUIDs are a problem then we might want to remove this
    if item.uuid
      unless item.title == course_hash[item.course_id].content_map_hash[item.uuid]['title']
        raise "Course content map doesn't match the item's other info"
      end
    end

    # Add item to the course
    course_hash[item.course_id].add_item(item)
  end

  #
  # At this point we have the list of courses built!
  #

  # previous impl for video extraction
  #data_json_video_files =
  #  data_json_files
  #  .select { |data_item| data_item['data_json']['resource_type'] == 'Video' && !data_item['data_json']['captions_file'].nil? }
  #  .reject { |data_item| data_item['data_json']['archive_url'].nil? || data_item['data_json']['archive_url'].empty? }

  #require 'byebug'; debugger
end

main(ARGV)
