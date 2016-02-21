require './nagiosservicecheckmetric'
require './nagiosservicecheck'
require './nagiosreporter'

output = `cat /proc/loadavg`

results = output.split(' ')

nsc = NagiosServiceCheck.new("load_avg")
nsm = NagiosServiceCheckMetric.new("loadavg_5", "int", results[0], 0.01, 10)
nsc.add_metric(nsm);
nsm = NagiosServiceCheckMetric.new("loadavg_10", "int", results[1], 5, 10)
nsc.add_metric(nsm);
nsm = NagiosServiceCheckMetric.new("loadavg_15", "int", results[2], 5, 0.02)
nsc.add_metric(nsm);
nsc.print_results

