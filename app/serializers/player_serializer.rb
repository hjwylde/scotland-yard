class PlayerSerializer < ActiveModel::Serializer
  attributes :id, :type, :name, :current_node_id, :ticket_counts, :token_counts

  def current_node_id
    object.current_node_id if object.detective? || @options[:current_player].try!(:criminal?)
  end

  def ticket_counts
    if @options[:ticket_counts]
      @options[:ticket_counts][object.id]
    else
      Rails.logger.warn 'Unoptimised call to PlayerSerializer: it should include a :ticket_counts argument'

      CountPlayerTicketsService.new(game: object.game).call[object.id]
    end
  end

  def token_counts
    if @options[:token_counts]
      @options[:token_counts][object.id]
    else
      Rails.logger.warn 'Unoptimised call to PlayerSerializer: it should include a :token_counts argument'

      CountPlayerTokensService.new(game: object.game).call[object.id]
    end
  end
end

