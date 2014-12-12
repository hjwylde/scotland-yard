require 'active_record/fixtures'

# Seed the nodes
NODES_PATH = "#{Rails.root}/db/seeds/nodes.json"
NODES = JSON.parse(File.read(NODES_PATH))

Node.destroy_all
NODES.each do |node|
  begin
    Node.create!(id: node['id'], origin: node['origin'], x: node['x'], y: node['y'])
  rescue Exception => e
    puts "error on node #{node}: #{e.message}"
    puts e.backtrace
  end
end

# Seed the routes
ROUTES_PATH = "#{Rails.root}/db/seeds/routes.json"
ROUTES = JSON.parse(File.read(ROUTES_PATH))

Route.destroy_all
ROUTES.each do |route|
  begin
    Route.create!(from_node_id: route['from_node_id'], to_node_id: route['to_node_id'], transport_mode: route['transport_mode'].to_sym)
    Route.create!(from_node_id: route['from_node_id'], to_node_id: route['to_node_id'], transport_mode: :black)
  rescue Exception => e
    puts "error on route #{route}: #{e.message}"
    puts e.backtrace
  end
end

