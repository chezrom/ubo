require 'mobile'

Player = Mobile:subclass('Player')


function Player:initialize(grid,x,y)
	Mobile.initialize(self,grid,30,x,y)
	
	self.dir=1
	self.move=false
	self.haveTail = false
end

function Player:draw()
	love.graphics.drawq(Player.image,Player.quads[self.dir],self.act_x,self.act_y)
end

function Player:update(dt)
	Mobile.update(self,dt)
	if self:atdest() then
		if self.move then
			self.move = false
			if self.grid:placeTail(self.x,self.y) then
				self.haveTail = true
			elseif self.haveTail then
				self.haveTail = false
				self.grid:setEvent(Grid.EVENT_CLOSE)
				return
			end
		end
		if love.keyboard.isDown("up") then
			if self.y > 1 then
				self.y = self.y - 1
				self.grid_y = self.grid_y - Grid.size
				self.sy = -1
				self.move = true
				self.dir=1
			end
		elseif love.keyboard.isDown("down") then
			if self.y < self.grid.hgrid then
				self.y = self.y + 1
				self.grid_y = self.grid_y + Grid.size
				self.sy = 1
				self.move = true
				self.dir=2
			end
		elseif love.keyboard.isDown("left") then
			if self.x > 1 then
				self.x = self.x - 1
				self.grid_x = self.grid_x - Grid.size
				self.sx = -1
				self.move = true
				self.dir=4
			end
		elseif love.keyboard.isDown("right") then
			if self.x < self.grid.wgrid then
				self.x = self.x + 1
				self.grid_x = self.grid_x + Grid.size
				self.sx = 1
				self.move = true
				self.dir=3
			end
		end
		if self.move and self.grid:isTail(self.x,self.y) then
				self.grid:setEvent(Grid.EVENT_SELF_HIT_TAIL)
				return
		end		
	end
end

function Player.static:load()

	local gsize = Grid.size
	local pid = love.image.newImageData(gsize*4,gsize)
	local pc={255,50,200}

	for x=0,pid:getWidth()-1 do
		for y=0,gsize-1 do
			pid:setPixel(x,y,0,0,0,0)
		end
	end
	local i = math.floor(gsize/4)
	local u = 0
	
	while 2*u <= gsize do
		for j = u,gsize-1-u do
			pid:setPixel(j,gsize-1-i,pc[1],pc[2],pc[3],255)
			pid:setPixel(j+gsize,i,pc[1],pc[2],pc[3],255)
			pid:setPixel(i+2*gsize,j,pc[1],pc[2],pc[3],255)
			pid:setPixel(4*gsize-1-i,j,pc[1],pc[2],pc[3],255)
		end
		i = i + 1
		u = u + 1
	end
	
	local img = love.graphics.newImage(pid)
	Player.static.image = img
	Player.static.quads={}
	for i =1,4 do
		Player.static.quads[i] = love.graphics.newQuad((i-1)*gsize,0,gsize,gsize,img:getWidth(),img:getHeight())
	end	
end