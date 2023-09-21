
require 'http'
require 'http/formdata'
require 'json'

module CanvasCourse
  def self.base_url
    'https://canvas.instructure.com/api/v1'
  end

  def self.token
    ENV['CANVAS_LMS_DEVELOPER_API_KEY']
  end

  def self.account_id
    ENV['CANVAS_LMS_ACCOUNT_ID']
  end

  def self.list
    JSON.parse(    
      HTTP.get("#{base_url}/accounts/#{account_id}/courses").to_s    
    )
  end

  def self.get(course_id:)
    JSON.parse(    
      HTTP.get("#{base_url}/accounts/#{account_id}/courses/#{course_id}").to_s    
    )
  end

  def self.create(course:)
    JSON.parse(    
      HTTP.post(    
        "#{base_url}/accounts/#{account_id}/courses",    
        json: {
          name: title,
          course_code: content,
          license: filename,
          is_public: false,
          is_public_to_auth_users: true,
          public_syllabus: true,
          public_description: "Hello World",
          allow_student_wiki_edits: false,
          allow_wiki_comments: false,
          allow_student_forum_attachments: false,
          open_enrollment: true,
          self_enrollment: true,
          restrict_enrollments_to_course_dates: false,
          hide_final_grades: true,
          offer: true,
          enroll_me: false,
          default_view: "modules",
          syllaubus_body: "Hello World",
          course_format: "online"
        }
      ).to_s    
    )
  end
end
