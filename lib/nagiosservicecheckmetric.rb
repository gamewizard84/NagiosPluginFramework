require "metric"

class NagiosServiceCheckMetric < Metric

EXIT_CODE =
      { unknown:  3,
        critical: 2,
        warning:  1,
        ok:       0 }
	
		
		attr_reader :metric, :warning, :critical, :exitcode, :doesAlert

        def initialize(name, measurement, value, warning, critical, doesAlert=true)


        	@metric = Metric.new(String(name), String(measurement), Float(value)) 
        	@warning = Float(warning)
        	@critical = Float(critical)
        	@doesAlert = doesAlert
        	                
        end

public	

		def state

			if @doesAlert == false
				return :ok
			end
			
			if @metric.value >= @critical
				@exitcode = :critical
				return :critical
			elsif @metric.value >= @warning
				@exitcode = :warning
				return :warning
			else
				@exitcode = :ok
				return :ok
			end
			
	    end
        

end


#ns = NagiosServiceCheckMetric.new("cat", "s", 5, 2, 10 )
#puts "State is --> #{ns.state}"
#puts "warning --> #{ns.warning}"
#puts "isWarning #{ns.isWarning?}"
