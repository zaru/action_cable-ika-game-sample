class BattleController < ApplicationController
  protect_from_forgery with: :null_session

  def index

  end

  def result
    File.open(Rails.root.join("tmp/result.png"), "wb") do |f|
      f.write(Base64.decode64(params[:image]))
    end

    battle = Battle.new
    battle.image_load
    render json: battle.result
  end

end
