# Be sure to restart your server when you modify this file. Action Cable runs in a loop that does not support auto reloading.
class BattleChannel < ApplicationCable::Channel
  def subscribed
    stream_from "player_#{uuid}"
  end

  def unsubscribed
    user = User.new(uuid)
    user.leave
  end

  def join(data)
    user = User.new(uuid)
    waiting unless user.join

    ActionCable.server.broadcast "player_#{uuid}", data.merge(user.params)
    stream_from "battle_channel"
    ActionCable.server.broadcast "battle_channel", { action: "opponent_join", avatar: user.avatar }
  end

  def attack(data)
    ActionCable.server.broadcast "battle_channel", data
  end

  def waiting
    ActionCable.server.broadcast "player_#{uuid}", { action: "waiting" }
  end
end
