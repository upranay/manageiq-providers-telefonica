module ManageIQ::Providers
  class Telefonica::StorageManager::CinderManager::Refresher < ManageIQ::Providers::BaseManager::ManagerRefresher
    def post_process_refresh_classes
      []
    end

    # Legacy parse
    #
    # @param ems [ManageIQ::Providers::BaseManager]
    def parse_legacy_inventory(ems)
      ::ManageIQ::Providers::Telefonica::StorageManager::CinderManager::RefreshParser.ems_inv_to_hashes(ems)
    end
  end
end
