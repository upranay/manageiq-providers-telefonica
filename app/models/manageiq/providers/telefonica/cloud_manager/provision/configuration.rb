module ManageIQ::Providers::Telefonica::CloudManager::Provision::Configuration
  def associate_floating_ip(ip_address)
    # TODO(lsmola) this should be moved to FloatingIp model
    destination.with_provider_object do |instance|
      instance.associate_address(ip_address.address)
    end
  end

  def configure_network_adapters
    @nics ||= begin
      networks = Array(options[:networks])

      # Set the first nic to whatever was selected in the dialog if not set by automate
      networks[0] ||= {:network_id => cloud_network.id} if cloud_network

      options[:networks] = convert_networks_to_telefonica_nics(networks)
    end
  end

  private

  def convert_networks_to_telefonica_nics(networks)
    networks.delete_blanks.collect { |nic| {"net_id" => CloudNetwork.find_by(:id => nic[:network_id]).ems_ref} }
  end
end
