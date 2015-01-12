class MakeMove
  class Error < StandardError
    attr_reader :errors

    def initialize(errors)
      super errors.inspect

      @errors = errors
    end
  end

  include Wisper::Publisher

  def initialize(player:, to_node:, ticket:, token: nil, cache: Hash.new({}))
    @player, @to_node, @ticket, @token = player, to_node, ticket.to_sym, token.try!(:to_sym)
    @cache = cache
  end

  def call
    @player.game.with_lock do
      check_move_is_valid

      move = create_move
      if @token == :double_move || current_round_finished?
        start_round unless @player.game.finished?
      end

      publish :success, move
    end
  rescue Error => e
    publish :fail, e.errors
  end

  private

  def check_move_is_valid
    policy = MoveValidPolicy.new(player: @player, to_node: @to_node, ticket: @ticket, token: @token,
                                 cache: { ticket_counts: ticket_counts, token_counts: token_counts })
    policy.on :fail do |errors|
      raise Error.new(errors)
    end

    policy.valid?
  end

  def create_move
    move = @player.moves.new(to_node: @to_node, ticket: @ticket)
    if !move.save
      raise Error.new(move.errors.full_messages)
    end

    move
  end

  def start_round
    start_round = StartRound.new(game: @player.game)
    start_round.on :fail do |errors|
      raise Error.new(errors)
    end

    start_round.call(override_round_finished_policy: @token == :double_move)
  end

  def current_round_finished?
    RoundFinishedPolicy.new(round: @player.game.current_round).finished?
  end

  def ticket_counts
    @cache[:ticket_counts] || CountPlayerTickets.new(game: @player.game).call
  end

  def token_counts
    @cache[:token_counts] || CountPlayerTokens.new(game: @player.game).call
  end
end

