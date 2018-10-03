module ManageIQ::Providers::Telefonica::Inventory::Persister::Definitions::NetworkCollections
  extend ActiveSupport::Concern

  include ManageIQ::Providers::Telefonica::Inventory::Persister::Definitions::Utils

  def initialize_network_inventory_collections
    add_cloud_networks

    add_cloud_subnets

    add_cloud_subnet_network_ports

    add_firewall_rules

    add_floating_ips

    add_network_ports

    add_network_routers

    add_security_groups
  end

  # ------ IC provider specific definitions -------------------------

  # model_class defined due to ovirt dependency
  def add_cloud_networks
    add_collection(network, :cloud_networks) do |builder|
      builder.add_properties(:model_class => ManageIQ::Providers::Telefonica::NetworkManager::CloudNetwork)

      network_ems_default_value(builder)
    end
  end

  # model_class defined due to ovirt dependency
  def add_cloud_subnets
    add_collection(network, :cloud_subnets) do |builder|
      builder.add_properties(:model_class => ManageIQ::Providers::Telefonica::NetworkManager::CloudSubnet)

      network_ems_default_value(builder)
    end
  end

  def add_cloud_subnet_network_ports
    add_collection(network, :cloud_subnet_network_ports) do |builder|
      builder.add_properties(
        :parent_inventory_collections => %i(vms network_ports)
      )
    end
  end

  def add_firewall_rules
    add_collection(network, :firewall_rules) do |builder|
      builder.add_properties(
        :manager_ref => %i(ems_ref)
      )
    end
  end

  # model_class defined due to ovirt dependency
  def add_floating_ips
    add_collection(network, :floating_ips) do |builder|
      builder.add_properties(:model_class => ManageIQ::Providers::Telefonica::NetworkManager::FloatingIp)

      network_ems_default_value(builder)
    end
  end

  def add_network_ports
    add_collection(network, :network_ports) do |builder|
      builder.add_properties(:model_class => ManageIQ::Providers::Telefonica::NetworkManager::NetworkPort)
      builder.add_properties(:delete_method => :disconnect_port)

      network_ems_default_value(builder)
    end
  end

  # model_class defined due to ovirt dependency
  def add_network_routers
    add_collection(network, :network_routers) do |builder|
      builder.add_properties(:model_class => ManageIQ::Providers::Telefonica::NetworkManager::NetworkRouter)

      network_ems_default_value(builder)
    end
  end

  # model_class defined due to ovirt dependency
  def add_security_groups
    add_collection(network, :security_groups) do |builder|
      builder.add_properties(:model_class => ManageIQ::Providers::Telefonica::NetworkManager::SecurityGroup)

      network_ems_default_value(builder)
    end
  end
end
