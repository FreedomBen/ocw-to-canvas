class LearningResourceType
  # Learning Resource Types
  #   - nil
  #   - Exams
  #   - Tools
  #   - Lecture Notes
  #   - Assignments
  #   - Recitations
  #   - Projects
  #   - Readings
  #   - Labs
  #   - Tutorials
  #   - Lecture Videos
  #   - Problem Sets
  #   - Exams with Solutions
  #   - Exam Materials
  #   - Problem Sets with Solutions
  #   - Course Introduction
  #   - Online Textbooks
  #   - Lecture Audio
  #   - Written Assignments
  #   - Videos
  #   - Online Textbook
  #   - Activity Assignments with Examples
  #   - Activity Assignments
  #   - Multiple Assignment Types
  #   - Image Gallery
  #   - Recitation Videos
  #   - Other Video
  #

  TYPES = {
    nil => -1,
    'Exams' => 0,
    'Tools' => 1,
    'Lecture Notes' => 2,
    'Assignments' => 3,
    'Recitations' => 4,
    'Projects' => 5,
    'Readings' => 6,
    'Labs' => 7,
    'Tutorials' => 8,
    'Lecture Videos' => 9,
    'Problem Sets' => 10,
    'Exams with Solutions' => 11,
    'Exam Materials' => 12,
    'Problem Sets with Solutions' => 13,
    'Course Introduction' => 14,
    'Online Textbooks' => 15,
    'Lecture Audio' => 16,
    'Written Assignments' => 17,
    'Videos' => 18,
    'Online Textbook' => 19,
    'Activity Assignments with Examples' => 20,
    'Activity Assignments' => 21,
    'Multiple Assignment Types' => 22,
    'Image Gallery' => 23,
    'Recitation Videos' => 24,
    'Other Video' => 25,
    'Tutorial Videos' => 26,
    'Instructor Insights' => 27,
    'Video Materials' => 28,
  }

  def self.get(resource_type)
    # make sure the learning resource types are valid
    unless TYPES[resource_type]
      raise "'#{resource_type}' is invalid learning resource type"
    end

    TYPES[resource_type]
  end

  def self.get_all(resource_types)
    resource_types.map { |rt| get(rt) }
  end

  def self.valid?(resource_type)
    !!TYPES[resource_type]
  end
end
