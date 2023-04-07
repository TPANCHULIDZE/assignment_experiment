class ExperimentController < ApplicationController
  def index
    #change input values here
    experiment = Experiment.new(96,
      [['Sample-1', 'Sample-2', 'Sample-3'], ['Sample-1', 'Sample-2', 'Sample-3']],
      [['pink'], ['green']],
      [20, 25]
    )
    
    @plates = experiment.call
    @height, @width = experiment.sizes
    
  rescue ArgumentError => e
    @error = 'invalid inpuit values'
  end
end
