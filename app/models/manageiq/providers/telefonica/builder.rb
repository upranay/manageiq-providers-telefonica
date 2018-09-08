class ManageIQ::Providers::Telefonica::Builder
  class << self
    def build_inventory(ems, target)
      case target
      when ManageIQ::Providers::Telefonica::CloudManager
        cloud_manager_inventory(ems, target)
      when ManageIQ::Providers::Telefonica::StorageManager::CinderManager
        inventory(
          ems,
          target,
          ManageIQ::Providers::Telefonica::Inventory::Collector::CinderManager,
          ManageIQ::Providers::Telefonica::Inventory::Persister::CinderManager,
          [ManageIQ::Providers::Telefonica::Inventory::Parser::CinderManager]
        )
      when ManageIQ::Providers::Telefonica::NetworkManager
        inventory(
          ems,
          target,
          ManageIQ::Providers::Telefonica::Inventory::Collector::NetworkManager,
          ManageIQ::Providers::Telefonica::Inventory::Persister::NetworkManager,
          [ManageIQ::Providers::Telefonica::Inventory::Parser::NetworkManager]
        )
      when ManagerRefresh::TargetCollection
        inventory(
          ems,
          target,
          ManageIQ::Providers::Telefonica::Inventory::Collector::TargetCollection,
          ManageIQ::Providers::Telefonica::Inventory::Persister::TargetCollection,
          [ManageIQ::Providers::Telefonica::Inventory::Parser::CloudManager,
           ManageIQ::Providers::Telefonica::Inventory::Parser::NetworkManager,
           ManageIQ::Providers::Telefonica::Inventory::Parser::CinderManager]
        )
      else
        # Fallback to ems refresh
        cloud_manager_inventory(ems, target)
      end
    end

    private

    def cloud_manager_inventory(ems, target)
      inventory(
        ems,
        target,
        ManageIQ::Providers::Telefonica::Inventory::Collector::CloudManager,
        ManageIQ::Providers::Telefonica::Inventory::Persister::CloudManager,
        [ManageIQ::Providers::Telefonica::Inventory::Parser::CloudManager]
      )
    end

    def inventory(manager, raw_target, collector_class, persister_class, parsers_classes)
      collector = collector_class.new(manager, raw_target)
      # TODO(lsmola) figure out a way to pass collector info, probably via target
      persister = persister_class.new(manager, raw_target, collector)

      ::ManageIQ::Providers::Telefonica::Inventory.new(
        persister,
        collector,
        parsers_classes.map(&:new)
      )
    end
  end
end
