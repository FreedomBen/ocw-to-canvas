#!/usr/bin/env bash


# List all courses
curl \
  -s \
  -H "Authorization: Bearer ${CANVAS_LMS_DEVELOPER_API_KEY}" \
  "https://staging-education.ameelio.xyz/api/v1/accounts/1/courses"

curl \
  --request POST \
  --header "Authorization: Bearer ${CANVAS_LMS_DEVELOPER_API_KEY}" \
  --header "Content-Type: application/json" \
  --data '{
      "course": {
        "name": "HelloWorld",
        "course_code": "HW101",
        "license": "cc_by_nc_sa",
        "is_public": false,
        "is_public_to_auth_users": true,
        "public_syllabus": true,
        "public_syllabus_to_auth": true,
        "public_description": "Hello World",
        "allow_student_wiki_edits": false,
        "allow_wiki_comments": false,
        "allow_student_forum_attachments": false,
        "open_enrollment": true,
        "self_enrollment": true,
        "restrict_enrollments_to_course_dates": false,
        "hide_final_grades": true,
        "offer": true,
        "enroll_me": false,
        "default_view": "modules",
        "syllabus_body": "Hello World",
        "course_format": "online"
      }
    }' \
  "https://staging-education.ameelio.xyz/api/v1/accounts/1/courses"


    CC BY-NC-SA 4.0
