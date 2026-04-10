# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Imports MIT OpenCourseWare (OCW) course content from an offline mirror and converts it into Canvas LMS format. Early-stage, pre-alpha Ruby project — sync to Canvas is not yet implemented.

## Running

```bash
ruby import-all.rb
```

No build step. No test framework, linter, or CI pipeline exists yet. No Gemfile — install the `http` gem manually (`gem install http`).

## Environment Variables

| Variable                       | Purpose                          |
| ------------------------------ | -------------------------------- |
| `CANVAS_LMS_DEVELOPER_API_KEY` | Canvas API authentication token  |
| `CANVAS_LMS_ACCOUNT_ID`       | Canvas account ID for API calls  |

## Architecture

**Entry point:** `import-all.rb` — scans an OCW content mirror directory for courses, parses `content_map.json` and `data.json` files, builds domain objects, serializes to JSON. Currently hardcoded to a single test course.

**Class hierarchy** — all resource types inherit from `Syncable` (base class with `sync()` interface, not yet implemented):

- `Course` (`lib/course.rb`) — top-level model. Holds metadata (title, instructors, department, topics, levels, term/year) and a collection of content items. Also defines `Instructor`, `CourseImageMetadata`, and `ImageMetadata` inner classes. Contains validation constants for `LEVELS`, `DEPARTMENT_NUMBERS`, and `TOPICS`.
- `Document` (`lib/document.rb`) — text/PDF resources
- `Video` (`lib/video.rb`) — video resources with youtube_key, archive_url, captions, transcripts
- `Image` (`lib/image.rb`) — image resources with image_metadata
- `Other` (`lib/other.rb`) — catch-all for unclassified resources

**Shared patterns across resource types:**
- Each has `from_orig_json(hash)` (factory from raw OCW data) and `from_json(json_hash)` (factory from serialized form)
- Each has `to_h` / `to_json` for serialization
- Each validates `learning_resource_types` against `LearningResourceType::TYPES`
- Each has a `uuid` accessor used to cross-reference with the course's `content_map_hash`

**Supporting classes:**
- `LearningResourceType` (`lib/learning_resource_type.rb`) — enum of 28+ OCW resource classifications (Lecture Videos, Problem Sets, Exams, etc.) with validation
- `CanvasCourse` (`lib/canvas/canvas_course.rb`) — Canvas REST API client module. Has `list`, `get`, `create` methods. The `create` method has placeholder field mappings and is not yet functional.

## Data Flow

1. `find` locates all `content_map.json` files under the OCW mirror directory
2. For each course: read `content_map.json` (UUID-to-filename mapping) and `data.json` (course metadata)
3. Separately find all `data.json` files, parse each into the appropriate resource type (Image/Document/Video/Other) via `from_orig_json`
4. Attach resources to their parent `Course` via `course_id`, cross-referencing UUIDs against `content_map_hash`
5. Serialize courses to JSON file
6. (Not yet implemented) Sync to Canvas via `CanvasCourse` API client

## Key Details

- OCW mirror paths are hardcoded in `import-all.rb` (constants `OCW_CONTENT_MIRROR_DIR`, `STATE_FILES_DIR`, plus inline paths in `main`)
- About 5% of data items are missing UUIDs — this is a known issue noted in a TODO comment
- `LearningResourceType.valid?` returns false for `nil` types (id -1 exists in TYPES hash but `!!TYPES[nil]` returns false since the value is -1, which is truthy — however `valid?` actually works because -1 is truthy; the real gap is that `nil` key lookups do work)
