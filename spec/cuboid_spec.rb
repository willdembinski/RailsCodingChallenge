require 'cuboid'

#This test is incomplete and, in fact, won't even run without errors.  
#  Do whatever you need to do to make it work and please add your own test cases for as many
#  methods as you feel need coverage
describe Cuboid do
		initConfig = {
		  origin:{
		    x:1,
		    y:1,
		    z:1
		  },
		  dimensions:{
		    length:2,
		    width:3,
		    height:1
		  }
		}
	before(:each) do
    @cube = Cuboid.new(initConfig)
  end



 
	describe "initialization" do
    it "should initialize with correct origin" do
      expect(@cube.origin).to eq({x:1,y:1,z:1})
    end

    it "should initialize with correct vertices" do
    	expect(@cube.vertices).to include(
    		vert1: {x:1,y:1,z:1}, #origin
    		vert2: {x:1,y:1,z:4},
    		vert3: {x:3,y:1,z:4},
    		vert4: {x:3,y:1,z:1},
    		vert5: {x:1,y:2,z:1}, #above origin
    		vert6: {x:1,y:2,z:4},
    		vert7: {x:3,y:2,z:4},
    		vert8: {x:3,y:2,z:1}
    	)
    end
  end



  describe "move_to" do
    it "updates origin attr after move" do
      expect(@cube.move_to!({x:1,y:2,z:3}).origin).to eq({x:1,y:2,z:3})
    end

    it "should update to correct vertices after moving" do
    	expect(@cube.vertices).to include(
    		vert1: {x:1,y:2,z:3}, #origin
    		vert2: {x:1,y:2,z:6},
    		vert3: {x:3,y:2,z:6},
    		vert4: {x:3,y:2,z:3},
    		vert5: {x:1,y:3,z:3}, #above origin
    		vert6: {x:1,y:3,z:6},
    		vert7: {x:3,y:3,z:6},
    		vert8: {x:3,y:3,z:3}
    	)
    end
  end


  describe "#rotate!" do
		it "updates correctly for x" do
  		expect(@cube.rotate!(:x).dimensions).to include(
  			length:2,#2/3/1
		    width:1,
		    height:3
  		)
		end
  	it "updates correctly for y" do
			expect(@cube.rotate!(:y).dimensions).to include(
		    length:1,
		    width:2,
		    height:3
			)
		end
		it "update correctly for z" do
			expect(@cube.rotate!(:z).dimensions).to include(
				length:3,
			  width:2,
			  height:1
			)
  	end
  end
  
  # describe "intersects?" do
  # end

end
