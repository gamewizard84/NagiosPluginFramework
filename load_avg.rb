require 'optparse'
require "rubygems"

require "NagiosFramework"

$nsc = NagiosServiceCheck.new("load_avg")

def get_loadavg

	output = `cat /proc/loadavg`

	results = output.split(' ')

	$nsc.add_metric(NagiosServiceCheckMetric.new("loadavg_5", "int", results[0],  $options[:warning], $options[:critical]))
	$nsc.add_metric(NagiosServiceCheckMetric.new("loadavg_10", "int", results[1], $options[:warning], $options[:critical]))
	$nsc.add_metric(NagiosServiceCheckMetric.new("loadavg_15", "int", results[2], $options[:warning], $options[:critical]))
	
end


$options = {:delay_messages => nil,:stuck_messages => nil, :warn => nil, :critical => nil}

parser = OptionParser.new do|opts|
opts.banner = "Usage: load_avg.rb [options]"
opts.on('-l', '--load-avg', 'Check for loadavg.') do |loadavg|
$options[:loadavg] = loadavg;
end

opts.on('-w', '--warn warn', Integer,  'Warn threshold') do |warn|
$options[:warning] = warn;
end

opts.on('-c', '--critical critical', Integer, 'Critical threshold') do |critical|
$options[:critical] = critical;
end

opts.on('-h', '--help', 'Displays Help') do
puts opts
exit
end
end

parser.parse!

if $options[:warning] == nil
        print 'Enter warn threshold: '
        $options[:warning] = gets.chomp
end

if $options[:critical] == nil
        print 'Enter critical threshold: '
        $options[:critical] = gets.chomp
end

if $options[:loadavg] != nil
	
	get_loadavg
		
end


# Print Results
$nsc.print_results(true)
exit $nsc.exit_code

