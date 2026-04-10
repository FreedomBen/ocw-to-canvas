# ocw-to-canvas

Import [MIT OpenCourseWare](https://ocw.mit.edu/) course content into [Canvas LMS](https://www.instructure.com/canvas).

> **Status:** Early development / work-in-progress. Parsing and serialization work; sync to Canvas is not yet implemented.

## What It Does

Reads an offline mirror of OCW course content, parses the metadata and resources (documents, videos, images, etc.), builds structured course objects, and (eventually) pushes them to a Canvas LMS instance via the Canvas REST API.

### Supported Resource Types

| Type     | Description                                                       |
| -------- | ----------------------------------------------------------------- |
| Document | PDFs, lecture notes, problem sets, and other text-based resources  |
| Video    | Lecture videos with YouTube keys, archive URLs, captions/transcripts |
| Image    | Course images with associated metadata                            |
| Other    | Any resource that doesn't fit the above categories                |

Each resource is classified using OCW's learning resource type taxonomy (Lecture Videos, Exams, Assignments, Problem Sets, etc.).

## Prerequisites

- Ruby (3.x recommended)
- The `http` gem:
  ```bash
  gem install http
  ```
- A local copy of the [OCW offline content mirror](https://ocw.mit.edu/) with the standard directory structure (each course containing `content_map.json` and `data.json` files)
- Canvas LMS API credentials (for the sync step, when implemented)

## Configuration

Set the following environment variables for Canvas API access:

```bash
export CANVAS_LMS_DEVELOPER_API_KEY="your-api-token"
export CANVAS_LMS_ACCOUNT_ID="your-account-id"
```

The OCW mirror path is currently hardcoded in `import-all.rb`. Update the constants at the top of that file to point to your local mirror:

```ruby
OCW_CONTENT_MIRROR_DIR = '/path/to/ocw-content-offline-live-production'
STATE_FILES_DIR = '/path/to/ocw-content-offline-live-production-state-files'
```

## Usage

```bash
ruby import-all.rb
```

This will:
1. Scan the OCW mirror directory for courses
2. Parse `content_map.json` (UUID-to-filename mapping) and `data.json` (course metadata) for each course
3. Build domain objects for all resources, validating learning resource types, departments, topics, and levels
4. Serialize the parsed courses to a JSON file

## Project Structure

```
import-all.rb              Entry point
lib/
  syncable.rb              Base class for all syncable objects
  course.rb                Course model (includes Instructor, CourseImageMetadata, ImageMetadata)
  document.rb              Document resource
  video.rb                 Video resource
  image.rb                 Image resource
  other.rb                 Generic resource
  learning_resource_type.rb  OCW resource type enum and validation
  canvas/
    canvas_course.rb       Canvas REST API client
scripts/
  curl.sh                  Example Canvas API curl commands
```

## License

[MIT](LICENSE)
