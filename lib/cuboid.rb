class Hash
  def swap!(a, b)
    self[a], self[b] = self[b], self[a] if key?(a) && key?(b)
    self
  end
end

class Cuboid
  attr_reader :origin, :dimensions, :vertices, :container,:maxes,:mins

	def initialize(config = {})
    @maxes = {x:0,y:0,z:0}
    @mins = {x:0,y:0,z:0}
    @dimensions = config[:dimensions]
    @origin = config[:origin]
    @container = config[:container] || nil
    update
    self
	end

  def move_to!(coords = {})
  	@origin[:x] = coords[:x] || @origin[:x]  
    @origin[:y] = coords[:y] || @origin[:y] 
    @origin[:z] = coords[:z] || @origin[:z]
    update
    self
  end

  def intersects?(other) #found this idea on stack overflow - makes sense to rule out where you can't collide, might be a more efficient way
    @maxes[:x] > other.mins[:x] &&
    @mins[:x] < other.maxes[:x] &&
    @maxes[:y] > other.mins[:y] &&
    @mins[:y] < other.maxes[:y] &&
    @maxes[:z] > other.mins[:z] &&
    @mins[:z] < other.maxes[:z]
  end

  def rotate!(ax) #assumes clockwise 90 deg - looking toward lower vals, meaning the plain's true 'origin'
    case ax
    when :x
      @origin = @vertices[:vert2]
      @dimensions.swap!(:width,:height)
    when :y
      @origin = @vertices[:vert4]
      @dimensions.swap!(:length,:width)
    when :z
      @origin = @vertices[:vert5]
      @dimensions.swap!(:length,:height)
    end
    update
    self
  end

  private

  def update
    setVerts
    setMaxAndMins
    reposition
  end

  def setMaxAndMins
    coords = {x:[],y:[],z:[]}
    @vertices.each do |key,hash|
      hash.each do |ax,val|
        coords[ax].push(val)
      end
    end
    coords.each do |ax,set|
      @maxes[ax] = set.max
      @mins[ax] = set.min
    end
  end

  def setVerts #This is assuming the 'origin' is a vertex - not the center of the cuboid
    #starting on bottom surface, going clockwise, assuming 1st is origin
    vert1 = @origin
    vert2 = {x:vert1[:x],y:vert1[:y],z:vert1[:z]+@dimensions[:width]}
    vert3 = {x:vert2[:x]+@dimensions[:length],y:vert2[:y],z:vert2[:z]}
    vert4 = {x:vert3[:x],y:vert3[:y],z:vert3[:z]-@dimensions[:width]}
    # now the top, based off vert1
    vert5 = {x:vert1[:x],y:vert1[:y]+@dimensions[:height],z:vert1[:z]}
    vert6 = {x:vert5[:x],y:vert5[:y],z:vert5[:z]+@dimensions[:width]}
    vert7 = {x:vert6[:x]+@dimensions[:length],y:vert6[:y],z:vert6[:z]}
    vert8 = {x:vert7[:x],y:vert7[:y],z:vert7[:z]-@dimensions[:width]}

    @vertices = {
      vert1:vert1,
      vert2:vert2,
      vert3:vert3,
      vert4:vert4,
      vert5:vert5,
      vert6:vert6,
      vert7:vert7,
      vert8:vert8
    }
  end

  def reposition
    unless @container.nil?
      @maxes.each do |key,val|
        if @maxes[key] > @container.maxes[key]
          self.move_to!({key => (@origin[key]-(@maxes[key] - @container.maxes[key]))}) #not as declarative as I would like
        end
      end
      @mins.each do |key,val|
        if @mins[key] < @container.mins[key]
          self.move_to!({key => @origin[key] + (@container.mins[key] - @mins[key])}) #not as declarative as I would like
        end
      end
    end
  end
end
