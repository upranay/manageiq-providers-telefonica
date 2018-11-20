describe ManageIQ::Providers::Telefonica::CloudManager::Provision::VolumeAttachment do
  before do
    @ems = FactoryGirl.create(:ems_telefonica_with_authentication)
    @template = FactoryGirl.create(:template_telefonica, :ext_management_system => @ems)
    @flavor = FactoryGirl.create(:flavor_telefonica)
    @volume = FactoryGirl.create(:cloud_volume_telefonica)

    @task = FactoryGirl.create(:miq_provision_telefonica,
                               :source  => @template,
                               :state   => 'pending',
                               :status  => 'Ok',
                               :options => {
                                 :instance_type => @flavor,
                                 :src_vm_id     => @template.id,
                                 :volumes       => [{:name => "custom_volume_1", :size => 2}]
                               })
  end

  context "#configure_volumes" do
    it "create volumes" do
      service = double
      allow(service).to receive_message_chain('volumes.create').and_return @volume
      allow(@task.source.ext_management_system).to receive(:with_provider_connection)\
        .with(:service => 'volume', :tenant_name => nil).and_yield(service)
      allow(@task).to receive(:instance_type).and_return @flavor

      requested_volume = {:name => "custom_volume_1", :size => 2, :uuid => @volume.id, :source_type => "volume",
                          :destination_type => "volume"}

      expect(@task.create_requested_volumes(@task.options[:volumes])).to eq [requested_volume]
    end
  end

  context "#check_volumes" do
    it "status pending" do
      pending_volume_attrs = {:source_type => "volume"}
      service = double
      allow(service).to receive_message_chain('volumes.get').and_return FactoryGirl.build(:cloud_volume_telefonica,
                                                                                          :status => "pending")
      allow(@task.source.ext_management_system).to receive(:with_provider_connection)\
        .with(:service => 'volume', :tenant_name => nil).and_yield(service)

      expect(@task.do_volume_creation_check([pending_volume_attrs])).to eq [false, "pending"]
    end

    it "check creation status available" do
      pending_volume_attrs = {:source_type => "volume"}
      service = double
      allow(service).to receive_message_chain('volumes.get').and_return FactoryGirl.build(:cloud_volume_telefonica,
                                                                                          :status => "available")
      allow(@task.source.ext_management_system).to receive(:with_provider_connection)\
        .with(:service => 'volume', :tenant_name => nil).and_yield(service)

      expect(@task.do_volume_creation_check([pending_volume_attrs])).to eq true
    end

    it "check creation status - not found" do
      pending_volume_attrs = {:source_type => "volume"}
      service = double
      allow(service).to receive_message_chain('volumes.get').and_return nil
      allow(@task.source.ext_management_system).to receive(:with_provider_connection)\
        .with(:service => 'volume', :tenant_name => nil).and_yield(service)

      expect(@task.do_volume_creation_check([pending_volume_attrs])).to eq [false, nil]
    end

    it "status error" do
      pending_volume_attrs = {:source_type => "volume"}
      service = double
      allow(service).to receive_message_chain('volumes.get').and_return FactoryGirl.build(:cloud_volume_telefonica,
                                                                                          :status => "error")
      allow(@task.source.ext_management_system).to receive(:with_provider_connection)\
        .with(:service => 'volume', :tenant_name => nil).and_yield(service)
      expect { @task.do_volume_creation_check([pending_volume_attrs]) }.to raise_error(MiqException::MiqProvisionError)
    end
  end
end
