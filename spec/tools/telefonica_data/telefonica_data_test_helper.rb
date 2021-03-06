require 'yaml'

class TelefonicaApiResult
  def initialize(data)
    @data = {:body => data}
  end

  def body
    @data[:body]
  end
end

class TelefonicaTestData
  def base_data_dir
    @base_data_dir ||= File.dirname(__FILE__)
  end

  def load_data(dir, test_data_file)
    @data ||= {}
    @data[dir] ||= {}
    @data[dir][test_data_file.to_sym] ||= {}
    @data[dir][test_data_file.to_sym][:data] ||= begin
      file = File.expand_path(File.join(base_data_dir, dir, "#{test_data_file}.yml"))
      File.exist?(file) ? YAML.load_file(file) : nil
    end
  end
end

class TelefonicaPerfTestData < TelefonicaTestData
  def data_dir
    @data_dir = "telefonica_perf_data"
  end

  def perf_data(test_data_file)
    load_data(data_dir, test_data_file)
  end

  def api_result(data)
    TelefonicaApiResult.new(data)
  end
end

class TelefonicaMeterListData < TelefonicaPerfTestData
  def list_meters(type)
    load_data(data_dir, type)
  end
end

class TelefonicaMetricStatsData < TelefonicaPerfTestData
  def get_statistics(meter_name, type = "standard")
    data = load_data(data_dir, type)
    data[meter_name]
  end
end
