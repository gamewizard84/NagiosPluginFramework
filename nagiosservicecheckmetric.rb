require "./metric"

class NagiosServiceCheckMetric < Metric

EXIT_CODE =
      { unknown:  3,
        critical: 2,
        warning:  1,
        ok:       0 }
	
		
		attr_reader :metric, :warning, :critical, :exitcode

        def initialize(name, measurement, value, warning, critical)


        	@metric = Metric.new(String(name), String(measurement), Float(value)) 
        	@warning = Float(warning)
        	@critical = Float(critical)
                
        end

public

		def state
			if @metric.value >= @critical
				@exitcode = EXIT_CODE[@metric.value]
				return :critical
			elsif @metric.value >= @warning
				@exitcode = EXIT_CODE[@metric.value]
				return :warning
			else
				@exitcode = EXIT_CODE[:ok]
				return :ok
			end
			
	    end
        

end

#me = Metric.new("hiss", "s", 33)
#ns = NagiosServiceCheckMetric.new(me, 3, 4)
#puts "warning --> #{ns.warning}"
#puts "isWarning #{ns.isWarning?}"
