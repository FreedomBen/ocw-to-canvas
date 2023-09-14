class OcwCourse
  attr_accessor :content_map_hash

  def initialize(id, content_map_hash)
    @content_map_hash = content_map_hash

    content_map_hash.each do |key, value|

    end
  end
end
