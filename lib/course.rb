class Course
  attr_reader :content_map_hash
  attr_reader :content_items
  attr_reader :course_id, :course_title, :course_description, :site_uid, :legacy_uid, :instructors, :department_numbers, :learning_resource_types, :topics, :primary_course_number, :extra_course_numbers, :term, :year, :level, :image_src, :course_image_metadata

  LEVELS = {
    # TODO
  }
  DEPARTMENT_NUMBERS = {
    'AAS' => 'Asian American Studies',
    # TODO
  }
  TOPICS = {
    # TODO
  }

  # event 20th 2 to 4

  def initialize(id, content_map_hash, data_json_hash)
    @course_id = id
    @content_map_hash = content_map_hash
    @content_items = []

    # These properties come from the top-level data.json file that is in the course directory
    @course_title = data_json_hash['course_title']
    @course_description = data_json_hash['course_description']
    @site_uid = data_json_hash['site_uid']  # Is this a UUID for the course defined by OCW?
    @legacy_uid = data_json_hash['legacy_uid']
    @instructors = data_json_hash['instructors'].map{|i| Instructor.new(i)}
    @department_numbers = data_json_hash['department_numbers']
    @learning_resource_types = data_json_hash['learning_resource_types']
    @topics = data_json_hash['topics'].flatten
    @primary_course_number = data_json_hash['primary_course_number']
    @extra_course_numbers = data_json_hash['extra_course_numbers']
    @term = data_json_hash['term']
    @year = data_json_hash['year']
    @level = data_json_hash['level']
    @image_src = data_json_hash['image_src']
    @course_image_metadata = CourseImageMetadata.new(data_json_hash['course_image_metadata'])
  end

  def add_item(item)
    # Make sure the course ID of the item matches our course_id
    unless @course_id == item.course_id
      raise "Course ID mismatch: #{item.course_id} != #{@course_id}"
    end

    @content_items << item
  end
end

class Instructor
  attr_reader :first_name, :last_name, :middle_initial, :salutation, :title

  def initialize(instructor_hash)
    @first_name = instructor_hash['first_name']
    @last_name = instructor_hash['last_name']
    @middle_initial = instructor_hash['middle_initial']
    @salutation = instructor_hash['salutation']
    @title = instructor_hash['title']
  end
end

class CourseImageMetadata
  attr_reader :content_type, :description, :draft, :file, :file_type, :image_metadata, :iscjklanguage, :learning_resource_types, :license, :ocw_type, :resourcetype, :title, :uid

  def initialize(hash)
    @content_type = hash['content_type']
    @description = hash['description']
    @draft = hash['draft']
    @file = hash['file']
    @file_type = hash['file_type']
    @image_metadata = ImageMetadata.new(hash['image_metadata'])
    @iscjklanguage = hash['iscjklanguage']
    @learning_resource_types = hash['learning_resource_types']
    @license = hash['license']
    @ocw_type = hash['ocw_type']
    @resourcetype = hash['resourcetype']
    @title = hash['title']
    @uid = hash['uid']
  end
end

class ImageMetadata
  attr_reader :caption, :credit, :image_alt

  def initialize(hash)
    @caption = hash['caption']
    @credit = hash['credit']
    @image_alt = hash['image_alt']
  end
end
