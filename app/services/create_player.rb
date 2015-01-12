class CreatePlayer
  class Error < StandardError
    attr_reader :errors

    def initialize(errors)
      super errors.inspect

      @errors = errors
    end
  end

  include Wisper::Publisher

  def initialize(game:, user:)
    @game, @user = game, user
  end

  def call(player_params)
    @game.with_lock do
      check_user_not_in_game

      player = create_player(player_params)
      check_game_is_valid

      start_round if game_full?

      publish :success, player
    end
  rescue Error => e
    publish :fail, e.errors
  end

  private

  def check_user_not_in_game
    if @game.players.any? { |player| player.user_id == @user.id }
      raise Error.new(['You have already joined this game'])
    end
  end

  def check_game_is_valid
    policy = GameValidPolicy.new(game: @game)
    policy.on :fail do |errors|
      raise Error.new(errors)
    end

    policy.valid?
  end

  def create_player(player_params)
    player = @game.players.new(player_params)
    player.user_id = @user.id
    if !player.save
      raise Error.new(player.errors.full_messages)
    end

    player
  end

  def game_full?
    @game.players.count == Game::NUMBER_OF_PLAYERS
  end

  def start_round
    start_round = StartRound.new(game: @game)
    start_round.on :fail do |errors|
      raise Error.new(errors)
    end

    start_round.call
  end
end

