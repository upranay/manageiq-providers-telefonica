require 'manageiq/providers/telefonica/legacy/telefonica_handle/handle'
require 'fog/telefonica'

describe TelefonicaHandle::Handle do
  before do
    @original_log = $fog_log
    $fog_log = double.as_null_object
  end

  after do
    $fog_log = @original_log
  end

  it ".url" do
    expect(described_class.url("::1")).to eq "http://[::1]"
  end

  context "errors from services" do
    before do
      @telefonica_svc = double('network_service')
      @telefonica_project = double('project')

      @handle = TelefonicaHandle::Handle.new("dummy", "dummy", "dummy")
      allow(@handle).to receive(:service_for_each_accessible_tenant).and_yield(@telefonica_svc, @telefonica_project)
    end

    it "ignores 404 errors from services" do
      expect(@telefonica_svc).to receive(:security_groups).and_raise(Fog::Network::Telefonica::NotFound)

      data = @handle.accessor_for_accessible_tenants("Network", :security_groups, :id)
      expect(data).to be_empty
    end

    it "ignores 404 errors from services returning arrays" do
      security_groups = double("security_groups").as_null_object
      expect(security_groups).to receive(:to_a).and_raise(Fog::Network::Telefonica::NotFound)

      expect(@telefonica_svc).to receive(:security_groups).and_return(security_groups)

      data = @handle.accessor_for_accessible_tenants("Network", :security_groups, :id)
      expect(data).to be_empty
    end
  end

  context "supports ssl" do
    it "handles default ssl type connections just fine" do
      fog      = double('fog')
      handle   = TelefonicaHandle::Handle.new("dummy", "dummy", "address")
      # auth_url = TelefonicaHandle::Handle.auth_url("address", 5000, "https")
      auth_url = nil

      expect(TelefonicaHandle::Handle).to receive(:raw_connect).with(
                                           "dummy",
                                           "dummy",
                                           nil,
                                           nil,
                                           "https://address/v2.0/tokens",
                                           "Compute",
                                           {:telefonica_tenant       => "admin",
                                            :telefonica_project_name => nil,
                                            :telefonica_project_domain_id => nil,
                                            :telefonica_user_domain_id    => nil,
                                            :telefonica_region       => nil,
                                            :connection_options     => {:ssl_verify_peer => false}})
                                           .once do |_, _, address|
        expect(address).to eq(auth_url)
        fog
      end
      expect(handle.connect(:tenant_name => "admin")).to eq(fog)
    end

    it "handles non ssl connections just fine" do
      fog      = double('fog')
      handle   = TelefonicaHandle::Handle.new("dummy", "dummy", "address", 5000, 'v2', 'non-ssl')
      # auth_url = TelefonicaHandle::Handle.auth_url("address", 5000, "http")
      auth_url = nil

      expect(TelefonicaHandle::Handle).to receive(:raw_connect).with(
                                           "dummy",
                                           "dummy",
                                            nil,
                                            nil,
                                           "http://address/v2.0/tokens",
                                           "Compute",
                                           {:telefonica_tenant       => "admin",
                                            :telefonica_project_name => nil,
                                            :telefonica_project_domain_id => nil,
                                            :telefonica_user_domain_id    => nil,
                                            :telefonica_region       => nil,
                                            :connection_options     => {}})
                                           .once do |_, _, address|
        expect(address).to eq(auth_url)
        fog
      end
      expect(handle.connect(:tenant_name => "admin")).to eq(fog)
    end

    it "handles ssl connections just fine, too" do
      fog            = double('fog')
      handle         = TelefonicaHandle::Handle.new("dummy", "dummy", "address", 5000, 'v2', 'ssl')
      # auth_url_ssl   = TelefonicaHandle::Handle.auth_url("address", 5000, "https")
      auth_url_ssl   = nil

      expect(TelefonicaHandle::Handle).to receive(:raw_connect).with(
                                           "dummy",
                                           "dummy",
                                           nil,
                                           nil,
                                           "https://address/v2.0/tokens",
                                           "Compute",
                                           {:telefonica_tenant       => "admin",
                                            :telefonica_project_name => nil,
                                            :telefonica_project_domain_id => nil,
                                            :telefonica_user_domain_id    => nil,
                                            :telefonica_region       => nil,
                                            :connection_options     => {:ssl_verify_peer => false}}) do |_, _, address|
        expect(address).to eq(auth_url_ssl)
        fog
      end

      expect(handle.connect(:tenant_name => "admin")).to eq(fog)
    end

    it "handles ssl with validation connections just fine, too" do
      fog            = double('fog')
      handle         = TelefonicaHandle::Handle.new("dummy", "dummy", "address", 5000, 'v2', 'ssl-with-validation')
      # auth_url_ssl   = TelefonicaHandle::Handle.auth_url("address", 5000, "https")
      auth_url_ssl = nil;

      expect(TelefonicaHandle::Handle).to receive(:raw_connect).with(
                                           "dummy",
                                           "dummy",
                                           nil,
                                           nil,
                                           "https://address/v2.0/tokens",
                                           "Compute",
                                           {:telefonica_tenant       => "admin",
                                            :telefonica_project_name => nil,
                                            :telefonica_project_domain_id => nil,
                                            :telefonica_user_domain_id    => nil,
                                            :telefonica_region       => nil,
                                            :connection_options     => {:ssl_verify_peer => true}}) do |_, _, address|
        expect(address).to eq(auth_url_ssl)
        fog
      end

      expect(handle.connect(:tenant_name => "admin")).to eq(fog)
    end

    it "handles ssl passing of extra params validation connections just fine, too" do
      fog            = double('fog')
      extra_options  = {
        :ssl_ca_file    => "file",
        :ssl_ca_path    => "path",
        :ssl_cert_store => "store_obj"
      }

      expected_options = {:telefonica_tenant       => "admin",
                          :telefonica_project_name => nil,
                          :telefonica_project_domain_id => nil,
                          :telefonica_user_domain_id    => nil,
                          :telefonica_region       => nil,
                          :connection_options     => {:ssl_verify_peer => true,
                                                      :ssl_ca_file     => "file",
                                                      :ssl_ca_path     => "path",
                                                      :ssl_cert_store  => "store_obj"}}

      handle           = TelefonicaHandle::Handle.new("dummy", "dummy", "address", 5000, 'v2', 'ssl-with-validation', extra_options)
      # auth_url_ssl     = TelefonicaHandle::Handle.auth_url("address", 5000, "https")
      auth_url_ssl     = nil

      expect(TelefonicaHandle::Handle).to receive(:raw_connect).with(
                                           "dummy",
                                           "dummy",
                                           nil,
                                           nil,
                                           "https://address/v2.0/tokens",
                                           "Compute",
                                           expected_options
                                           ) do |_, _, address|
        expect(address).to eq(auth_url_ssl)
        fog
      end

      expect(handle.connect(:tenant_name => "admin")).to eq(fog)
    end
  end

  context "supports regions" do
    it "handles connections with region just fine" do
      fog      = double('fog')
      handle   = TelefonicaHandle::Handle.new("dummy", "dummy", "address", 5000, 'v2', 'non-ssl', :region => 'RegionOne')
      # auth_url = TelefonicaHandle::Handle.auth_url("address", 5000, "http")
      auth_url = nil

      expect(TelefonicaHandle::Handle).to receive(:raw_connect).with(
        "dummy",
        "dummy",
        nil,
        nil,
        "http://address/v2.0/tokens",
        "Compute",
        :telefonica_tenant       => "admin",
        :telefonica_project_name => nil,
        :telefonica_project_domain_id => nil,
        :telefonica_user_domain_id    => nil,
        :telefonica_region       => 'RegionOne',
        :connection_options     => {}).once do |_, _, address|
          expect(address).to eq(auth_url)
          fog
        end
      expect(handle.connect(:tenant_name => "admin")).to eq(fog)
    end
  end
end
