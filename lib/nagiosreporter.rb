require "nagiosservicecheckmetric"
require "nagiosservicecheck"

class NagiosReporter

attr_accessor :perf_metric

def initialize	
	@nagiosServiceCheckMetric = Hash.new
	@perf_metric = false

	
end

def generate_performance_metrics(metric)

	perf_metric = "#{metric.metric.name}=#{metric.metric.value};#{metric.warning};#{metric.critical};;;\n"

return perf_metric

end


public 

def perf_metric?
	@perf_metric
end

def add_metric(nagiosServiceCheckMetric)

	if nagiosServiceCheckMetric.is_a?(NagiosServiceCheckMetric)
		@nagiosServiceCheckMetric.merge!("#{nagiosServiceCheckMetric.metric.name}" => nagiosServiceCheckMetric) 
	else
		raise "Error: Not a nagiosServiceCheckMetric"
	end

end

def clear
	@nagiosServiceCheckMetric.clear
end

def print_state

	state = ""

	@nagiosServiceCheckMetric.each do | key, nagiosServiceCheckMetric |

		if nagiosServiceCheckMetric.state == :critical			
			state = nagiosServiceCheckMetric.state
			break
		elsif (nagiosServiceCheckMetric.state == :warning) && (state != "CRITICAL")
			state = nagiosServiceCheckMetric.state
		
		elsif state != :warning && state != :critical			
			state = :ok
		
		end
				
	end
		

	return state.upcase
			
	    
		
	end

def print_metrics

	output = ""
	perf_data = ""

	first_line = true;
	second_line = true;

	@nagiosServiceCheckMetric.each do | key, nagiosServiceCheckMetric |

		if perf_metric?			
			if first_line
				first_line = false
				output += "#{key} - #{nagiosServiceCheckMetric.metric.value} | #{generate_performance_metrics(nagiosServiceCheckMetric)}"
			elsif second_line
				second_line = false
				perf_data += " | " + generate_performance_metrics(nagiosServiceCheckMetric)
				output += "#{key} - #{nagiosServiceCheckMetric.metric.value}\n"
			else
				perf_data += generate_performance_metrics(nagiosServiceCheckMetric)
				output += "#{key} - #{nagiosServiceCheckMetric.metric.value}\n"
			end
		else
			output += "#{key} - #{nagiosServiceCheckMetric.metric.value}\n"
		end # end outer if

		
end #end of loop

# lets append the rest of the perf_data
if perf_data.length > 0
	output.chomp!()
	output += perf_data
end

	

	output.insert(0, "#{print_state.upcase} ")
	puts output


end

end

# Body - Test
#nsc = NagiosServiceCheck.new("hiss")
#nsc.add_metric(NagiosServiceCheckMetric.new("hiss", "s", 800, 600, 700))
#nsc.add_metric(NagiosServiceCheckMetric.new("dog", "s", 600, 555, 777))
#nsc.add_metric(NagiosServiceCheckMetric.new("walf", "s", 2, 4, 6 ))
#nsc.print_results(true)
#nsc.print_state
#puts "done"
#na = NagiosReporter.new()


#na.addMetric(nsm)
#na.addMetric(nsm1)
#na.addMetric(nsm2);
#na.perf_metric = true
#na.print_metrics
