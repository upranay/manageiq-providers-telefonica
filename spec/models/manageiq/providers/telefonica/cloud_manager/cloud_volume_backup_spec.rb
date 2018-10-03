describe ManageIQ::Providers::Telefonica::CloudManager::CloudVolumeBackup do
  let(:ems) { FactoryGirl.create(:ems_telefonica) }
  let(:tenant) { FactoryGirl.create(:cloud_tenant_telefonica, :ext_management_system => ems, :name => 'test') }
  let(:raw_cloud_volume_backup) { double }

  let(:cloud_volume) do
    FactoryGirl.create(:cloud_volume_telefonica,
                       :ext_management_system => ems,
                       :name                  => 'test',
                       :ems_ref               => 'one_id',
                       :cloud_tenant          => tenant)
  end

  let(:cloud_volume_backup) do
    FactoryGirl.create(:cloud_volume_backup_telefonica,
                       :ext_management_system => ems,
                       :name                  => 'test backup',
                       :ems_ref               => 'two_id',
                       :cloud_volume          => cloud_volume)
  end

  before do
    allow(cloud_volume_backup).to receive(:cloud_tenant).and_return(tenant)
    allow(cloud_volume_backup).to receive(:with_provider_object).and_yield(raw_cloud_volume_backup)
    allow(raw_cloud_volume_backup).to receive(:destroy)
    allow(raw_cloud_volume_backup).to receive(:restore)
  end

  it "handles cloud volume" do
    expect(cloud_volume_backup.cloud_volume).to eq(cloud_volume)
  end

  context 'raw_backup_restore' do
    it 'restores backup' do
      expect(raw_cloud_volume_backup).to receive(:restore)
      cloud_volume_backup.raw_restore(cloud_volume)
    end
  end

  context 'raw_delete_backup' do
    it 'deletes backup' do
      expect(raw_cloud_volume_backup).to receive(:destroy)
      cloud_volume_backup.raw_delete
    end
  end
end
