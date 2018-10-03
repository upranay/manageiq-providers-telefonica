describe ManageIQ::Providers::Telefonica::NetworkManager::CloudSubnet do
  let(:ems) { FactoryGirl.create(:ems_telefonica) }
  let(:tenant) { FactoryGirl.create(:cloud_tenant_telefonica, :ext_management_system => ems) }
  let(:ems_network) { ems.network_manager }
  let(:cloud_subnet) do
    FactoryGirl.create(:cloud_subnet_telefonica,
                       :ext_management_system => ems_network,
                       :name                  => 'test_subnet',
                       :ems_ref               => 'network_id',
                       :cloud_tenant          => tenant)
  end

  let(:network_router) do
    FactoryGirl.create(:network_router_telefonica,
                       :ext_management_system => ems_network,
                       :name                  => 'test',
                       :ems_ref               => 'one_id',
                       :cloud_tenant          => tenant)
  end

  let(:service) do
    service = double("Fog service")
    service
  end

  let(:raw_network_routers) do
    raw_network_routers = double("network routers")
    allow(CloudSubnet).to receive(:find).with(cloud_subnet.id).and_return(cloud_subnet)
    allow(ExtManagementSystem).to receive(:find).with(ems_network.id).and_return(ems_network)
    allow(ems_network.parent_manager).to receive(:connect)
      .with(hash_including(:service => 'Network', :tenant_name => tenant.name)).and_return(service)
    raw_network_routers
  end

  let(:bad_request) do
    response = Excon::Response.new
    response.status = 400
    response.body = '{"NeutronError": {"message": "bad request"}}'
    Excon::Errors.status_error({:expects => 200}, response)
  end

  before do
    raw_network_routers
  end

  describe 'network router actions' do
    context ".create" do
      it 'catches errors from provider' do
        expect(service).to receive(:create_router).and_raise(bad_request)
        expect do
          ems_network.create_network_router(:cloud_tenant => tenant, :name => "network")
        end.to raise_error(MiqException::MiqNetworkRouterCreateError)
      end
    end

    context "#update_network_router" do
      it 'catches errors from provider' do
        expect(service).to receive(:update_router).and_raise(bad_request)
        expect { network_router.raw_update_network_router({}) }.to raise_error(MiqException::MiqNetworkRouterUpdateError)
      end
    end

    context "#delete_network_router" do
      it 'catches errors from provider' do
        expect(service).to receive(:delete_router).and_raise(bad_request)
        expect { network_router.raw_delete_network_router }.to raise_error(MiqException::MiqNetworkRouterDeleteError)
      end
    end

    context "#raw_add_interface" do
      it 'catches errors from provider' do
        expect(service).to receive(:add_router_interface).and_raise(bad_request)
        expect { network_router.raw_add_interface(cloud_subnet.id) }.to raise_error(MiqException::MiqNetworkRouterAddInterfaceError)
      end
    end

    context "#raw_remove_interface" do
      it 'catches errors from provider' do
        expect(service).to receive(:remove_router_interface).and_raise(bad_request)
        expect { network_router.raw_remove_interface(cloud_subnet.id) }.to raise_error(MiqException::MiqNetworkRouterRemoveInterfaceError)
      end
    end
  end
end
