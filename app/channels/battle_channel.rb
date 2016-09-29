# Be sure to restart your server when you modify this file. Action Cable runs in a loop that does not support auto reloading.
class BattleChannel < ApplicationCable::Channel
  def subscribed
    stream_from "player_#{uuid}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def join(data)
    colors = %w(gray orange blue pink green mint purple)
    data["color"] = colors.sample
    ActionCable.server.broadcast "player_#{uuid}", data
    stream_from "battle_channel"
  end

  def attack(data)
    ActionCable.server.broadcast "battle_channel", data
  end
end
