require 'cuboid'

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
    it "Should initialize with correct max vals" do
      expect(@cube.maxes).to include(
        x:3,
        y:2,
        z:4
      )
    end
    it "Should initialize with correct min vals" do
      expect(@cube.mins).to include(
        x:1,
        y:1,
        z:1
      )
    end
  end

  describe "#move_to!" do
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
    it "Should move with correct max vals" do
      expect(@cube.maxes).to include(
        x:3,
        y:3,
        z:6
      )
    end
    it "Should move with correct min vals" do
      expect(@cube.mins).to include(
        x:1,
        y:2,
        z:3
      )
    end
  end

  describe "#rotate!" do
		it "rotates correctly for x axis" do
  		expect(@cube.rotate!(:x).dimensions).to include(
  			length:2,#2/3/1
		    width:1,
		    height:3
  		)
		end
  	it "rotates correctly for y axis" do
			expect(@cube.rotate!(:y).dimensions).to include(
		    length:1,
		    width:2,
		    height:3
			)
		end
		it "rotates correctly for z axis" do
			expect(@cube.rotate!(:z).dimensions).to include(
				length:3,
			  width:2,
			  height:1
			)
  	end
  end
  
  describe "#intersects?" do

    cube1Config = {
      origin:{
        x:1,
        y:1,
        z:1
      },
      dimensions:{
        length:4,
        width:4,
        height:4
      }
    }
    intersectConfig = {
      origin:{
        x:2,
        y:2,
        z:2
      },
      dimensions:{
        length:5,
        width:5,
        height:5
      }
    }
    noIntersectConfig = {
      origin:{
        x:10,
        y:10,
        z:10
      },
      dimensions:{
        length:1,
        width:1,
        height:1
      }
    }

    it "identifies an intersecting cube" do # this isn't dry, but its easier to read later atm.
      @cube1 = Cuboid.new(cube1Config);
      @cube2 = Cuboid.new(intersectConfig);
      expect(@cube1.intersects?(@cube2)).to be true
    end

    it "identifies an non-intersecting cube" do
      @cube1 = Cuboid.new(cube1Config);
      @cube3 = Cuboid.new(noIntersectConfig);
      expect(@cube1.intersects?(@cube3)).to be false
    end
  end

  describe "parent container intersect" do
    containerConfig = {
      origin:{
        x:0,
        y:0,
        z:0
      },
      dimensions:{
        length:100,
        width:100,
        height:100
      }
    }

    container = Cuboid.new(containerConfig)

    cubeConfig = {
      origin:{
        x:0,
        y:0,
        z:0
      },
      dimensions:{
        length:10,
        width:10,
        height:10
      },
      container: container
    }

    cube = Cuboid.new(cubeConfig)

    it "identifies intersects on X axis (neg)" do
      expect(cube.move_to!({x:-1,y:0,z:0}).origin).to include(
        x:0,
        y:0,
        z:0
      )
    end
    it "identifies intersects on X axis (pos)" do
      expect(cube.move_to!({x:100,y:0,z:0}).origin).to include(
        x:90,
        y:0,
        z:0
      )
    end
    it "identifies intersects on Y axis (neg)" do
      expect(cube.move_to!({x:0,y:-1,z:0}).origin).to include(
        x:0,
        y:0,
        z:0
      )
    end
    it "identifies intersects on Y axis (pos)" do
      expect(cube.move_to!({x:0,y:100,z:0}).origin).to include(
        x:0,
        y:90,
        z:0
      )
    end
    it "identifies intersects on Z axis (neg)" do
      expect(cube.move_to!({x:0,y:0,z:-1}).origin).to include(
        x:0,
        y:0,
        z:0
      )
    end
    it "identifies intersects on Z axis (pos)" do
      expect(cube.move_to!({x:0,y:0,z:100}).origin).to include(
        x:0,
        y:0,
        z:90
      )
    end

    it "shifts when rotated into an intersecting position" do
      wideCubeConfig = {
        origin:{
          x:90,
          y:0,
          z:0
        },
        dimensions:{
          length:10,
          width:20,
          height:10
        },
        container: container
      }
      wideCube = Cuboid.new(wideCubeConfig)
      expect(wideCube.rotate!(:y).origin).to include(
        x:80,
        y:0,
        z:0
      )
    end
  end

end
