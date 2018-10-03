class ManageIQ::Providers::Telefonica::Inventory < ManageIQ::Providers::Inventory
  require_nested :Collector
  require_nested :Parser
  require_nested :Persister

  # Default manager for building collector/parser/persister classes
  # when failed to get class name from refresh target automatically
  def self.default_manager_name
    "CloudManager"
  end

  def self.parser_classes_for(_ems, target)
    case target
    when InventoryRefresh::TargetCollection
      [ManageIQ::Providers::Telefonica::Inventory::Parser::CloudManager,
       ManageIQ::Providers::Telefonica::Inventory::Parser::NetworkManager,
       ManageIQ::Providers::Telefonica::Inventory::Parser::StorageManager::CinderManager]
    else
      super
    end
  end
end
