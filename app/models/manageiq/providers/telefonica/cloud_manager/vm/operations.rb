module ManageIQ::Providers::Telefonica::CloudManager::Vm::Operations
  extend ActiveSupport::Concern

  include_concern 'Guest'
  include_concern 'Power'
  include_concern 'Relocation'
  include_concern 'Snapshot'

  def raw_destroy
    raise "VM has no #{ui_lookup(:table => "ext_management_systems")}, unable to destroy VM" unless ext_management_system
    with_notification(:vm_destroy,
                      :options => {
                        :subject => self,
                      }) do
      with_provider_object(&:destroy)
    end
    self.update_attributes!(:raw_power_state => "DELETED")
  end
end
