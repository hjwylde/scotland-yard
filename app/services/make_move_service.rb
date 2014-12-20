class MakeMoveService
  class Error < StandardError
    attr_reader :errors

    def initialize(errors)
      super errors.inspect

      @errors = errors
    end
  end

  include Wisper::Publisher

  def initialize(player:, to_node:, ticket:)
    @player, @to_node, @ticket = player, to_node, ticket.to_sym
  end

  def call
    @player.game.with_lock do
      check_move_is_valid

      move = create_move

      publish :success, move
    end
  rescue Error => e
    publish :fail, e.errors
  end

  private

  def check_move_is_valid
    policy = MoveValidPolicy.new(player: @player, to_node: @to_node, ticket: @ticket)
    policy.on :fail do |errors|
      raise Error.new(errors)
    end

    policy.valid?
  end

  def create_move
    move = @player.moves.new(round: @player.game.current_round, to_node: @to_node, ticket: @ticket)
    if !move.save
      raise Error.new(move.errors.full_messages)
    end

    move
  end
end

