require "influxdb"
require "nagiosservicecheckmetric"
require "nagiosservicecheck"
require "yaml"

class InfluxDBReporter

def initialize ()
		
	@influxDBConnection =  InfluxDB::Client.new 

    

    @data = {
  			values: {  },
  			tags: {  },
  			 
			}


end

def load_from_file(file_path)

	if File.exist?(file_path)
		influxdb_config = YAML.load_file(file_path)[0]['influxdb']

		@influxDBConnection = InfluxDB::Client.new database: influxdb_config['database'],
													host: influxdb_config['host'],
													username: influxdb_config['username'],
													password: influxdb_config['password'],
													use_ssl: influxdb_config['use_ssl']

	    puts "built connection string to --> #{influxdb_config['host']}, username --> #{influxdb_config['username']} pass --> #{influxdb_config['password']}"

	else
		raise "Unable to find file --> #{file_path}"
	end

end

def test
	@data.each do | key, value |
	puts "key = #{key}"
	puts "value = #{value}"
end
	
end

def add_field(nagiosServiceCheckMetric, fieldName=nagiosServiceCheckMetric.metric.name)

	if nagiosServiceCheckMetric.is_a?(NagiosServiceCheckMetric)		
		@data[:values].merge!("#{fieldName}" => nagiosServiceCheckMetric.metric.value) 
	else		
		raise "Error: Not a nagiosServiceCheckMetric.  You gave a #{nagiosServiceCheck.class}"
	end

end

def add_tag(tagName, tagValue)

	@data[:tags].merge!("#{tagName}" => "#{tagValue}")

end

def write_point(measurement_name)

	@influxDBConnection.write_point(measurement_name, @data)

end

def add_NagiosServiceCheck(nagiosServiceCheck)

	if nagiosServiceCheck.is_a?(NagiosServiceCheck)
		
		nagiosServiceCheck.get_metrics.each do | key, metric |
			@data[:values].merge!("#{key}" => metric.metric.value);
		end		 
	else
		puts nagiosServiceCheckMetric.class
		raise "Error: Not a nagiosServiceCheckMetric"
	end

end

end # End of class

