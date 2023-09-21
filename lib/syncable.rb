class Syncable
  attr_accessor :created_at, :id

  def initialize()
    @created_at = Time.now
    @canvas_id = nil
  end

  def created?
    @created_at != nil
  end

  def set_created_at(time)
    @created_at = time
  end

  def sync
    raise NotImplementedError
  end
end
