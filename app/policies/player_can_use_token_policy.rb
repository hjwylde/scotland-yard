class PlayerCanUseTokenPolicy
  include Wisper::Publisher

  def initialize(player:)
    @player = player

    @errors = []
  end

  # Policy for determining if a player can use a given token
  # A player can use a token
  # 1) they have more than 0 of that token type
  def can_use?(token:, count:)
    check_token_count(token, count)

    publish(:fail, @errors) if @errors.any?

    @errors.empty?
  end

  private

  def check_token_count(token, count)
    if count <= 0
      @errors << "You have no #{token} tokens"
    end
  end
end

