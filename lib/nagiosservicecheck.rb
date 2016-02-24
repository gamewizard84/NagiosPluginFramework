#require 'nagiosreporter'
#require 'nagiosservicecheckmetric'


class NagiosServiceCheck 


EXIT_CODE =
      { unknown:  3,
        critical: 2,
        warning:  1,
        ok:       0 }
        
	attr_accessor :name, :nagiosReporter

	def initialize(serviceName)

		@name = serviceName
		@nagiosReporter = NagiosReporter.new
		@nagiosServiceCheckMetric = Hash.new
	
	end

	def add_metric(nagiosServiceCheckMetric)

		if !nagiosServiceCheckMetric.is_a?(NagiosServiceCheckMetric)
			raise "The metric must be of the NagiosServiceCheckMetrics"
		
		else
			@nagiosServiceCheckMetric.merge!("#{nagiosServiceCheckMetric.metric.name}" => nagiosServiceCheckMetric)			
		end


	end

	def print_results(perf_metric=false)
		 				
		# Clearing NagiosReporter 
		
		@nagiosReporter.clear

		if perf_metric
			@nagiosReporter.perf_metric = true

		end

		@nagiosServiceCheckMetric.each do | key, metric |
			@nagiosReporter.add_metric(metric)
		end

		@nagiosReporter.print_metrics

	end

	def exit_code

		state = print_state
		state.downcase;		
		    
		    if state == :critical
				return EXIT_CODE[state]				
			elsif state == :warning
				return EXIT_CODE[state]
			else
				return EXIT_CODE[:ok]
				
			end
			
	    
		
	end

	def print_state

	state = ""

	@nagiosServiceCheckMetric.each do | key, nagiosServiceCheckMetric |

		if nagiosServiceCheckMetric.state == :critical			
			state = nagiosServiceCheckMetric.state
			break
		elsif (nagiosServiceCheckMetric.state == :warning) && (state != "critical")
			state = nagiosServiceCheckMetric.state
		
		elsif state != :warning && state != :critical			
			state = :ok
		
		end
				
	end
		

	return state
			
	    
		
	end

end