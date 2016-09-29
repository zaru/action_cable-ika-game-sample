class User

  attr_accessor :uuid, :color, :avatar

  def initialize(uuid)
    @redis = Redis.new
    @uuid = uuid
    @color = color
    @avatar = avatar
  end

  def self.active_user_size
    Redis.new.smembers("users").size
  end

  def self.vacant?
    (active_user_size < 4) ? true : false
  end

  def params
    {
      uuid: @uuid,
      color: @color,
      avatar: @avatar
    }
  end

  def join
    return false unless User.vacant?
    @redis.sadd("users", @uuid)
    @redis.set(@uuid, params)
  end

  def leave
    @redis.srem("users", @uuid)
    @redis.del(@uuid)
  end

  private

  def color
    colors = %w(gray orange blue pink green mint purple)
    colors.sample
  end

  def avatar
    (1..4).to_a.sample
  end

end