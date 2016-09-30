class User

  attr_accessor :uuid, :color, :avatar

  def initialize(uuid)
    @uuid = uuid
    params = REDIS.get(@uuid)
    if params
      params = JSON.parse(params)
      @color = params["color"]
      @avatar = params["avatar"]
    else
      @color = color
      @avatar = avatar
    end
  end

  def self.active_user_size
    REDIS.smembers("users").size
  end

  def self.vacant?
    (active_user_size < Battle.max_user) ? true : false
  end

  def self.carry_up
    REDIS.lpop("waiting")
  end

  def self.all
    users = {}
    uuids = REDIS.smembers("users")
    uuids.each do |uuid|
      users[uuid] = User.new(uuid).params
    end
    users
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
    REDIS.sadd("users", @uuid)
    REDIS.set(@uuid, params.to_json)
  end

  def leave
    REDIS.srem("users", @uuid)
    REDIS.del(@uuid)
  end

  def waiting
    REDIS.rpush("waiting", @uuid)
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