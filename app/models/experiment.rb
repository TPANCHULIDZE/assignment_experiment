class Experiment
  include PlateModule #from ./concerns/plate_module.rb

  def initialize(plate_size, samples, reagents, replicates)
    @plate_size = plate_size
    @samples = samples

    @reagents = reagents
    @replicates = replicates
  rescue ArgumentError => e
    raise e
  end

  def call
    generate
  rescue ArgumentError => e
    raise e
  end

  def sizes
    @plate_size == 96 ? [8, 12] : [16, 24]
  end
end