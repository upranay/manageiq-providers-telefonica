describe ManageIQ::Providers::Telefonica::NetworkManager::CloudSubnet do
  let(:ems) { FactoryGirl.create(:ems_telefonica) }
  let(:tenant) { FactoryGirl.create(:cloud_tenant_telefonica, :ext_management_system => ems) }
  let(:ems_network) { ems.network_manager }
  let(:cloud_subnet) do
    FactoryGirl.create(:cloud_subnet_telefonica,
                       :ext_management_system => ems_network,
                       :name                  => 'test',
                       :ems_ref               => 'one_id',
                       :cloud_tenant          => tenant)
  end

  let(:service) do
    service = double("Fog service")
    service
  end

  let(:raw_cloud_subnets) do
    raw_cloud_subnets = double("cloud subnets")
    allow(ExtManagementSystem).to receive(:find).with(ems_network.id).and_return(ems_network)
    allow(ems_network.parent_manager).to receive(:connect)
      .with(hash_including(:service => 'Network', :tenant_name => tenant.name)).and_return(service)
    raw_cloud_subnets
  end

  let(:bad_request) do
    response = Excon::Response.new
    response.status = 400
    response.body = '{"NeutronError": {"message": "bad request"}}'
    Excon::Errors.status_error({:expects => 200}, response)
  end

  before do
    raw_cloud_subnets
  end

  describe 'cloud subnet actions' do
    context ".create" do
      it 'catches errors from provider' do
        expect(service).to receive_message_chain(:subnets, :new).and_raise(bad_request)
        expect do
          ems_network.create_cloud_subnet(:cloud_tenant => tenant)
        end.to raise_error(MiqException::MiqCloudSubnetCreateError)
      end
    end

    context "#update_cloud_subnet" do
      it 'catches errors from provider' do
        expect(service).to receive(:update_subnet).and_raise(bad_request)
        expect { cloud_subnet.raw_update_cloud_subnet({}) }.to raise_error(MiqException::MiqCloudSubnetUpdateError)
      end
    end

    context "#delete_cloud_subnet" do
      it 'catches errors from provider' do
        expect(service).to receive(:delete_subnet).and_raise(bad_request)
        expect { cloud_subnet.raw_delete_cloud_subnet }.to raise_error(MiqException::MiqCloudSubnetDeleteError)
      end
    end
  end
end
