# NagiosPluginFramework

The NagiosPluginFramework project is to help you write Nagios plugins.  The goal is to simplify handling things like warning, critical, and ok thresholds.  

## Instructions

Clone the repo

`git clone https://github.com/gamewizard84/NagiosPluginFramework.git`

Build the gem

`gem build  NagiosFramework.gemspec`

Install the gem

`gem install NagiosFramework-0.1.1.gem`

## Using the framework 

Inside your script file add in 

require "NagiosFramework"

Then instantiation an instance of the "NagiosServiceCheck" as so.

$nsc = NagiosServiceCheck.new("load_avg")

Add metrics to the NagiosServiceCheck as shown below

The parameters for NagiosServiceCheckMetric are [metric name, measurement, value, warning, critical

$nsc.add_metric(NagiosServiceCheckMetric.new("loadavg_5", "int", 0.05,  1, 10))
$nsc.add_metric(NagiosServiceCheckMetric.new("loadavg_10", "int", 0.05, 1, 10))
$nsc.add_metric(NagiosServiceCheckMetric.new("loadavg_15", "int", 0.10, 1, 10))

If you would also like to send metrics to InfluxDB you can do so as below.

# Optional Add On
$influxDB = InfluxDBReporter.new()
$influxDB.load_from_file("/home/raymond/Desktop/NagiosFramework/conf/nagiosframework.yaml")

Example of nagiosframework.yaml

`-  influxdb:
    host: example.host.com
    username: user
    password: password
    database: database_name    
    use_ssl: true`

Finally you can print out the results to Nagios as shown below.

# Print Results 
Passing in true so that it also outputs performance data.  The NagiosServiceCheck already knows if the check is warning / critical / ok and represents it in the output

$nsc.print_results(true)

#####Adding in the InfluxDBReporter so that it can be used.

$influxDB.add_NagiosServiceCheck($nsc)

#####Adding in a custom tag to the InfluxDB Point

$influxDB.add_tag("Application_Type", "Linux")

#####Writing point

$influxDB.write_point($nsc.name)

#####returning exit code to Nagios.  The framework automatically returns the worst case for the exit code.

exit $nsc.exit_code


For a detailed explaniation feel free to check the load_avg.rb script.