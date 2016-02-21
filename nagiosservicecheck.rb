#require './nagiosreporter'
#require './nagiosservicecheckmetric'


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

		@nagiosServiceCheckMetric.each do | metric |
		    
		    if @metric.value >= @critical
				return EXIT_CODE[@metric.value]				
			elsif @metric.value >= @warning
				return EXIT_CODE[@metric.value]
			else
				return EXIT_CODE[:ok]
				
			end
			
	    
		end
	end

	def print_state

	state = ""

	@nagiosServiceCheckMetric.each do | key, nagiosServiceCheckMetric |
		puts "we have #{nagiosServiceCheckMetric.state}"
		if nagiosServiceCheckMetric.state == :critical			
			state = nagiosServiceCheckMetric.state
			break
		elsif (nagiosServiceCheckMetric.state == :warning) && (state != "CRITICAL")
			state = nagiosServiceCheckMetric.state
			puts "State set as --> #{state}"
		elsif state != :warning && state != :critical
			puts "state is --> #{state}"
			state = :ok
			puts "State set as --> #{state}"		
		end
				
	end

		puts "state is #{state}" 

	return state.upcase
			
	    
		
	end

end