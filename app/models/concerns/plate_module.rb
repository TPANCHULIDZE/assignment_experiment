module PlateModule
  def generate
    check_validate
    generate_result
    create_plates

    ## if you want to see plate on console uncomment line below
    # print_plates
    
    @plates
  rescue ArgumentError => e
    raise e
  end

  private

  def check_validate
    valid_plate_size = @plate_size == 96 || @plate_size == 384

    valid_sizes = @samples.size == @reagents.size && @samples.size == @replicates.size
    
    valid_samlpes = @samples.all? { |sample| sample.is_a?(Array) && sample.uniq.size == sample.size && sample.all? { |ele| ele.is_a?(String) } }
    
    valid_reagents = @reagents.all? { |reagent| reagent.is_a?(Array) && reagent.all? { |ele| ele.is_a?(String)} } && @reagents.flatten.uniq.size == @reagents.flatten.size

    valid_replicates = @replicates.all? { |replicate| replicate.is_a?(Integer) }

    is_valid = valid_plate_size && valid_sizes && valid_samlpes && valid_reagents && valid_replicates

    unless is_valid
      raise ArgumentError.new('values are invalid')
    end
  end

  def generate_result
    @result = []

    @samples.each_with_index do |sample, ind|
      @result += sample.product(@reagents[ind]) * @replicates[ind]
    end

    @result.sort! 
  end

  def create_plates
    max_row, max_col = @plate_size == 96 ? [8, 12] : [16, 24]
    
    @plates = []

    plate = Array.new(max_row) {Array.new(max_col) { nil}}
    result_size = @result.size
    ind = 0
    col = 0
    row = 0
    while result_size > ind
      if col < max_col
        plate[row][col] = @result[ind]
        ind += 1
        col += 1
      elsif col == max_col && row + 1 < max_row
        row += 1
        col = 0
      else
        @plates << plate
        plate = Array.new(max_row) {Array.new(max_col) { nil}}
        row = 0
        col = 0
      end
    end

    if plate[0][0] != nil
      @plates << plate
    end
  end

  def print_plates
    @plates.each_with_index do |plate, ind|
      puts "plate #{ind+1}"
      puts "---------------------------------------------------------------"
      plate.each do |row|
        p row
        puts '---------------------------------------------------------------'
      end
      puts '###############################################################'
    end
  end

end 