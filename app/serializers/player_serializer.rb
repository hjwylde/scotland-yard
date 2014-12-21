class PlayerSerializer < ActiveModel::Serializer
  attributes :id, :type, :name, :current_node_id, :ticket_counts

  def ticket_counts
    if @options[:ticket_counts]
      @options[:ticket_counts][object.id]
    else
      Rails.logger.warn 'Unoptimised call to PlayerSerializer: it should include a :ticket_counts argument'

      object.ticket_counts
    end
  end
end

