module ManageIQ::Providers
  class Telefonica::NetworkManager::Refresher < ManageIQ::Providers::BaseManager::ManagerRefresher
    def post_process_refresh_classes
      []
    end
  end
end
