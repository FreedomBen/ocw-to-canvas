class Course
  attr_reader :content_map_hash
  attr_reader :content_items
  attr_reader :course_id, :course_title, :course_description, :site_uid, :legacy_uid, :instructors, :department_numbers, :learning_resource_types, :topics, :primary_course_number, :extra_course_numbers, :term, :year, :level, :image_src, :course_image_metadata

  LEVELS = {
    'Non Credit' => 0,
    'High School' => 1,
    'Undergraduate' => 2,
    'Graduate' => 3
  }

  DEPARTMENT_NUMBERS = {
    "1" => 1,
    "2" => 2,
    "3" => 3,
    "4" => 4,
    "5" => 5,
    "6" => 6,
    "7" => 7,
    "8" => 8,
    "9" => 9,
    "10" => 10,
    "11" => 11,
    "12" => 12,
    "14" => 14,
    "15" => 15,
    "16" => 16,
    "17" => 17,
    "18" => 18,
    "20" => 20,
    "22" => 22,
    "24" => 24,
    "21A" => 25,
    "21G" => 26,
    "21H" => 27,
    "21L" => 28,
    "21M" => 29,
    "CC" => 30,
    "CMS-W" => 31,
    "EC" => 32,
    "ES" => 33,
    "ESD" => 34,
    "HST" => 35,
    "IDS" => 36,
    "MAS" => 37,
    "PE" => 38,
    "RES" => 39,
    "STS" => 40,
    "WGS" => 41
  }

  # This can't be used as an enum because all the values are "0"
  TOPICS = {
    'Academic Writing' => 0,
    'Accounting' => 1,
    'Aerodynamics' => 2,
    'Aerospace Engineering' => 3,
    'African American Studies' => 4,
    'African History' => 5,
    'Algebra and Number Theory' => 6,
    'Algorithms and Data Structures' => 7,
    'American History' => 0,
    'American Literature' => 0,
    'American Politics' => 0,
    'Analytical Chemistry' => 0,
    'Anatomy and Physiology' => 0,
    'Ancient History' => 0,
    'Anthropology' => 0,
    'Applied Mathematics' => 0,
    'Aquatic Sciences and Water Quality Control' => 0,
    'Archaeology' => 0,
    'Architectural Design' => 0,
    'Architectural Engineering' => 0,
    'Architectural History and Criticism' => 0,
    'Architecture' => 0,
    'Art History' => 0,
    'Artificial Intelligence' => 0,
    'Asian History' => 0,
    'Asian Studies' => 0,
    'Astrodynamics' => 0,
    'Astrophysics' => 0,
    'Atmospheric Science' => 0,
    'Atomic, Molecular, Optical Physics' => 0,
    'Avionics' => 0,
    'Bioastronautics' => 0,
    'Biochemistry' => 0,
    'Biography' => 0,
    'Biological Anthropology' => 0,
    'Biological Engineering' => 0,
    'Biology' => 0,
    'Biomaterials' => 0,
    'Biomechanics' => 0,
    'Biomedical Enterprise' => 0,
    'Biomedical Instrumentation' => 0,
    'Biomedical Signal and Image Processing' => 0,
    'Biomedicine' => 0,
    'Biophysics' => 0,
    'Biostatistics' => 0,
    'Biotechnology' => 0,
    'Buildings' => 0,
    'Business' => 0,
    'Business Ethics' => 0,
    'Calculus' => 0,
    'Cancer' => 0,
    'Cell Biology' => 0,
    'Cell and Tissue Engineering' => 0,
    'Cellular and Molecular Medicine' => 0,
    'Chemical Engineering' => 0,
    'Chemistry' => 0,
    'Chinese' => 0,
    'Civil Engineering' => 0,
    'Classical Mechanics' => 0,
    'Classics' => 0,
    'Climate' => 0,
    'Climate Studies' => 0,
    'Cognitive Science' => 0,
    'Combustion' => 0,
    'Comedy' => 0,
    'Communication' => 0,
    'Community Development' => 0,
    'Comparative History' => 0,
    'Comparative Literature' => 0,
    'Comparative Politics' => 0,
    'Composite Materials' => 0,
    'Computation' => 0,
    'Computation and Systems Biology' => 0,
    'Computational Biology' => 0,
    'Computational Modeling and Simulation' => 0,
    'Computational Science and Engineering' => 0,
    'Computer Design and Engineering' => 0,
    'Computer Networks' => 0,
    'Computer Science' => 0,
    'Condensed Matter Physics' => 0,
    'Construction Management' => 0,
    'Creative Writing' => 0,
    'Criticism' => 0,
    'Cryptography' => 0,
    'Cultural Anthropology' => 0,
    'Curriculum and Teaching' => 0,
    'Dance' => 0,
    'Data Mining' => 0,
    'Developmental Biology' => 0,
    'Developmental Economics' => 0,
    'Differential Equations' => 0,
    'Digital Media' => 0,
    'Digital Systems' => 0,
    'Discrete Mathematics' => 0,
    'Drama' => 0,
    'Dynamics and Control' => 0,
    'Earth Science' => 0,
    'Ecology' => 0,
    'Econometrics' => 0,
    'Economics' => 0,
    'Education Policy' => 0,
    'Educational Technology' => 0,
    'Electric Power' => 0,
    'Electrical Engineering' => 0,
    'Electricity' => 0,
    'Electromagnetism' => 0,
    'Electronic Materials' => 0,
    'Electronics' => 0,
    'Energy' => 0,
    'Engineering' => 0,
    'English as a Second Language' => 0,
    'Entrepreneurship' => 0,
    'Environmental Design' => 0,
    'Environmental Engineering' => 0,
    'Environmental Management' => 0,
    'Environmental Policy' => 0,
    'Environmental Science' => 0,
    'Epidemiology' => 0,
    'Epistemology' => 0,
    'Ethics' => 0,
    'Ethnography' => 0,
    'European History' => 0,
    'European and Russian Studies' => 0,
    'Fiction' => 0,
    'Film and Video' => 0,
    'Finance' => 0,
    'Financial Economics' => 0,
    'Fine Arts' => 0,
    'Fluid Mechanics' => 0,
    'Fossil Fuels' => 0,
    'French' => 0,
    'Fuel Cells' => 0,
    'Functional Genomics' => 0,
    'Game Design' => 0,
    'Game Theory' => 0,
    'Gender Studies' => 0,
    'Genetics' => 0,
    'Geobiology' => 0,
    'Geochemistry' => 0,
    'Geography' => 0,
    'Geology' => 0,
    'Geophysics' => 0,
    'Geotechnical Engineering' => 0,
    'German' => 0,
    'Global Poverty' => 0,
    'Globalization' => 0,
    'Graphic Design' => 0,
    'Graphics and Visualization' => 0,
    'Guidance and Control Systems' => 0,
    'Health Care Management' => 0,
    'Health and Exercise Science' => 0,
    'Health and Medicine' => 0,
    'High Energy Physics' => 0,
    'Higher Education' => 0,
    'Historical Methods' => 0,
    'Historiography' => 0,
    'History' => 0,
    'History of Science and Technology' => 0,
    'Housing Development' => 0,
    'Human-Computer Interfaces' => 0,
    'Humanities' => 0,
    'Hydrodynamics' => 0,
    'Hydrodynamics and Coastal Engineering' => 0,
    'Hydrogen and Alternatives' => 0,
    'Hydrology and Water Resource Systems' => 0,
    'Immunology' => 0,
    'Indigenous Studies' => 0,
    'Industrial Organization' => 0,
    'Industrial Relations and Human Resource Management' => 0,
    'Information Technology' => 0,
    'Innovation' => 0,
    'Inorganic Chemistry' => 0,
    'Intellectual History' => 0,
    'International Development' => 0,
    'International Economics' => 0,
    'International Literature' => 0,
    'International Relations' => 0,
    'Italian' => 0,
    'Japanese' => 0,
    'Jewish History' => 0,
    'Labor Economics' => 0,
    'Language' => 0,
    'Latin American History' => 0,
    'Latin and Caribbean Studies' => 0,
    'Leadership' => 0,
    'Legal Studies' => 0,
    'Linear Algebra' => 0,
    'Linguistics' => 0,
    'Literature' => 0,
    'Logic' => 0,
    'Macroeconomics' => 0,
    'Management' => 0,
    'Marketing' => 0,
    'Materials Science and Engineering' => 0,
    'Materials Selection' => 0,
    'Mathematical Analysis' => 0,
    'Mathematical Logic' => 0,
    'Mathematics' => 0,
    'Mechanical Design' => 0,
    'Mechanical Engineering' => 0,
    'Media Studies' => 0,
    'Medical Imaging' => 0,
    'Medieval History' => 0,
    'Mental Health' => 0,
    'Metallurgical Engineering' => 0,
    'Metaphysics' => 0,
    'Microbiology' => 0,
    'Microeconomics' => 0,
    'Microtechnology' => 0,
    'Middle Eastern History' => 0,
    'Middle Eastern Studies' => 0,
    'Military History' => 0,
    'Military Studies' => 0,
    'Modern History' => 0,
    'Molecular Biology' => 0,
    'Molecular Engineering' => 0,
    'Music' => 0,
    'Music History' => 0,
    'Music Performance' => 0,
    'Music Theory' => 0,
    'Nanotechnology' => 0,
    'Neurobiology' => 0,
    'Neuroscience' => 0,
    'Nonfiction Prose' => 0,
    'Nuclear' => 0,
    'Nuclear Engineering' => 0,
    'Nuclear Materials' => 0,
    'Nuclear Physics' => 0,
    'Nuclear Systems, Policy, and Economics' => 0,
    'Numerical Simulation' => 0,
    'Ocean Engineering' => 0,
    'Ocean Exploration' => 0,
    'Ocean Structures' => 0,
    'Oceanic Pollution Control' => 0,
    'Oceanography' => 0,
    'Operating Systems' => 0,
    'Operations Management' => 0,
    'Organic Chemistry' => 0,
    'Organizational Behavior' => 0,
    'Particle Physics' => 0,
    'Pathology and Pathophysiology' => 0,
    'Performance Arts' => 0,
    'Periodic Literature' => 0,
    'Pharmacology and Toxicology' => 0,
    'Philosophy' => 0,
    'Philosophy of Language' => 0,
    'Phonology' => 0,
    'Photography' => 0,
    'Physical Chemistry' => 0,
    'Physical Education and Recreation' => 0,
    'Physics' => 0,
    'Planetary Science' => 0,
    'Poetry' => 0,
    'Political Economy' => 0,
    'Political Philosophy' => 0,
    'Political Science' => 0,
    'Polymeric Materials' => 0,
    'Polymers' => 0,
    'Portuguese' => 0,
    'Probability and Statistics' => 0,
    'Process Control Systems' => 0,
    'Programming Languages' => 0,
    'Project Management' => 0,
    'Propulsion Systems' => 0,
    'Proteomics' => 0,
    'Psychology' => 0,
    'Public Administration' => 0,
    'Public Economics' => 0,
    'Public Health' => 0,
    'Public Policy' => 0,
    'Quantum Mechanics' => 0,
    'Radiological Engineering' => 0,
    'Real Estate' => 0,
    'Regional Planning' => 0,
    'Regional Politics' => 0,
    'Relativity' => 0,
    'Religion' => 0,
    'Religious Architecture' => 0,
    'Renewables' => 0,
    'Rhetoric' => 0,
    'Robotics and Control Systems' => 0,
    'Science' => 0,
    'Science and Technology Policy' => 0,
    'Security Studies' => 0,
    'Semantics' => 0,
    'Sensory-Neural Systems' => 0,
    'Separation Processes' => 0,
    'Signal Processing' => 0,
    'Social Anthropology' => 0,
    'Social Justice' => 0,
    'Social Medicine' => 0,
    'Social Science' => 0,
    'Social Welfare' => 0,
    'Society' => 0,
    'Sociology' => 0,
    'Software Design and Engineering' => 0,
    'Solid Mechanics' => 0,
    'Spanish' => 0,
    'Spectroscopy' => 0,
    'Speech Pathology' => 0,
    'Stem Cells' => 0,
    'Structural Biology' => 0,
    'Structural Engineering' => 0,
    'Structural Mechanics' => 0,
    'Supply Chain Management' => 0,
    'Surveying' => 0,
    'Sustainability' => 0,
    'Syntax' => 0,
    'Synthetic Biology' => 0,
    'Systems Design' => 0,
    'Systems Engineering' => 0,
    'Systems Optimization' => 0,
    'Teaching and Education' => 0,
    'Technical Writing' => 0,
    'Technology' => 0,
    'Telecommunications' => 0,
    'The Developing World' => 0,
    'Theater' => 0,
    'Theatrical Design' => 0,
    'Theoretical Physics' => 0,
    'Theory of Computation' => 0,
    'Thermodynamics' => 0,
    'Topology and Geometry' => 0,
    'Transport Processes' => 0,
    'Transportation' => 0,
    'Transportation Engineering' => 0,
    'Transportation Planning' => 0,
    'Urban Planning' => 0,
    'Urban Studies' => 0,
    'Virology' => 0,
    'Visual Arts' => 0,
    'Women\'s Studies' => 0,
    'World History' => 0
  }

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
    @learning_resource_types = data_json_hash['learning_resource_types']
    @primary_course_number = data_json_hash['primary_course_number']
    @extra_course_numbers = data_json_hash['extra_course_numbers']
    @term = data_json_hash['term']
    @year = data_json_hash['year']
    @image_src = data_json_hash['image_src']
    @course_image_metadata = CourseImageMetadata.new(data_json_hash['course_image_metadata'])

    @levels = data_json_hash['level']
    @department_numbers = data_json_hash['department_numbers']
    @topics = data_json_hash['topics'].flatten

    # Verify the level is valid
    data_json_hash['level'].flatten.each do |level|
      unless LEVELS.include?(level)
        raise "Course had invalid level: #{level}"
      end
    end

    # Verify the department numbers are valid
    data_json_hash['department_numbers'].flatten.each do |department_number|
      unless DEPARTMENT_NUMBERS.include?(department_number)
        raise "Course had invalid department number: #{department_number}"
      end
    end

    # Verify the topics are valid
    data_json_hash['topics'].flatten.each do |topic|
      unless TOPICS.include?(topic)
        raise "Course had invalid topic: #{topic}"
      end
    end
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
