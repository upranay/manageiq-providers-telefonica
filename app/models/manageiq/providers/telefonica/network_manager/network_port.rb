class ManageIQ::Providers::Telefonica::NetworkManager::NetworkPort < ::NetworkPort
  def disconnect_port
    # Some ports link subnets to routers, so
    # sever that association if the port is removed
    cloud_subnets.each do |subnet|
      subnet.network_router = nil
      subnet.save!
    end
    delete
  end

  def self.display_name(number = 1)
    n_('Network Port (Telefonica)', 'Network Ports (Telefonica)', number)
  end
end
