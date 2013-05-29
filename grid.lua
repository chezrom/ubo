
Grid = Mobile:subclass('Grid')

Grid.static.mapColor={ {128,128,60},{0,0,0}, {128,0,0},{0,128,0},{0,0,128},{128,128,0},{128,0,128},{0,128,128} }
Grid.static.backgroundColor={50,100,75}

Grid.static.size = 16

Grid.static.EVENT_CLOSE = "close"
Grid.static.EVENT_SELF_HIT_TAIL = "YOU HIT THE UNFISHED WALL"
Grid.static.EVENT_SELF_HIT_UBO  = "selfhitubo"
Grid.static.EVENT_UBO_HIT_TAIL  = "AN UBO HIT THE UNFISHED WALL"

function Grid:initialize(ymin)
	
	self.hgrid = math.floor((love.graphics.getHeight() - ymin)/Grid.size)
	self.wgrid = math.floor(love.graphics.getWidth()/Grid.size)
	
	self.start_y = love.graphics.getHeight() - Grid.size * self.hgrid
	self.start_x = 0
	
	self.map={}
	self.player={}
	self.ubos={}
	self.spriteBatch = love.graphics.newSpriteBatch(Grid.image,self.hgrid*self.wgrid)

	self.event=nil
	self.active=false	
	self.percent = 0
	self.success = false

	self.level = 0
	
end

function Grid:setEvent(event) 
	if not self.event then
		self.event = event
	end
end

function Grid:buildBatch()
	self.spriteBatch:bind()
	self.spriteBatch:clear()
	for y=1,self.hgrid do
		for x=1,self.wgrid do
			local c = self.map[y][x]
			if c > 0 then
				self.spriteBatch:addq(Grid.quads[c],(x-1)*Grid.size,(y-1)*Grid.size)
			end
		end
	end
	self.spriteBatch:unbind()
end

function Grid:getScreenCoord(x,y)
	return (x-1)*Grid.size + self.start_x,(y-1)*Grid.size + self.start_y
end

function Grid:startLevel(level)
	--game_state.label = string.format('LEVEL %d',nqix)
	self.level = level
	
	for y=1,self.hgrid do
		self.map[y]={}
		for x=1,self.wgrid do
			if y == 1 or y == self.hgrid then
				self.map[y][x]=2
			elseif x == 1 or x == self.wgrid then
				self.map[y][x]=2
			else
				self.map[y][x]=0
			end
		end
	end

	self.player = Player(self,math.floor(self.wgrid/2),self.hgrid)
	
	self.ubos = {}
	for i=1,level do
		self.ubos[i] = Ubo(self,math.random(3,self.wgrid-3),math.random(3,self.hgrid-3))
	end

	self:buildBatch()
	self.active=true
	self.success=false
	self.percent=0

end

function Grid:draw()

	love.graphics.setColor(120,120,120)
	love.graphics.rectangle('fill',0,0,love.graphics.getWidth(),self.start_y)
	
	love.graphics.setFont(Game.font)
	love.graphics.setColor(Game.color)
	love.graphics.print(string.format('LEVEL %2d : %2d %% CLAIMED',self.level,self.percent),20,0)


	love.graphics.setColor(Grid.backgroundColor)
	love.graphics.rectangle('fill',self.start_x,self.start_y,self.wgrid*Grid.size,self.hgrid*Grid.size)

	love.graphics.setColor(255,255,255)
	love.graphics.draw(self.spriteBatch,self.start_x,self.start_y)

	for iq = 1, #self.ubos do
		self.ubos[iq]:draw()
	end

	self.player:draw()
end

function Grid:placeTail(x,y)
	if self.map[y][x] == 0 then
		self.map[y][x] = 1
		self.spriteBatch:addq(Grid.quads[1],(x-1)*Grid.size,(y-1)*Grid.size)
		return true
	else
		return false
	end
end

function Grid:isCellFree(x,y)
	return self.map[y][x] == 0
end

function Grid:isTail(x,y)
	return self.map[y][x] == 1
end

function Grid:animate(dt)
	for iq = 1, #self.ubos do
		self.ubos[iq]:animate(dt)
	end
end

function Grid:update(dt)
	self:animate(dt)
	if not self.active then
		return
	end
	self.event = nil
	self.player:update(dt)
	if self.event and self:treatEvent() then
		return
	end
	for iq = 1, #self.ubos do
		self.ubos[iq]:update(dt)
		if self.event and self:treatEvent() then
			return
		end
	end

end

function Grid:isFinished()
	return not self.active
end

function Grid:isSuccess()
	return self.success
end

function Grid:treatEvent() 
	if self.event == Grid.static.EVENT_CLOSE then
		self.event = nil

		local nbFilled = self:gainLand()
		local percent = nbFilled/((self.wgrid-2)*(self.hgrid-2))
		self.percent = math.floor(percent*100)
		if percent > 0.75 then
			self.active=false
			self.success=true
			return true
		end
		return false
	else
		self.active=false
		self.success=false
		return self.event
	end
end

function Grid:gainLand()
	local newcol = math.random(3,#Grid.mapColor)
	
	for y=1,self.hgrid do
		for x=1,self.wgrid do
			local c = self.map[y][x]
			if c == 1 then
				self.map[y][x] = 2
			elseif c == 0 then
				self.map[y][x] = newcol
			end
		end
	end
	
	for iq = 1, #self.ubos do
		local qix = self.ubos[iq]
		if self.map[qix.y][qix.x] ~= 0 then
			self:_floodFill(qix.x,qix.y,newcol,0)
		end
	end
	local total = (self.wgrid-2)*(self.hgrid-2)
	for y=2,self.hgrid-1 do
		for x=2,self.wgrid-1 do
			if self.map[y][x] == 0 then
				total = total - 1
			end
		end
	end
	self:buildBatch()
	return total
end

function Grid:_floodFill(x,y,tc,rc)
	if self.map[y][x] ~= tc then
		return 
	end
	self.map[y][x] = rc
	self:_floodFill(x,y-1,tc,rc)
	self:_floodFill(x,y+1,tc,rc)
	self:_floodFill(x-1,y,tc,rc)
	self:_floodFill(x+1,y,tc,rc)
end

function Grid.static:load(gsize)

	Grid.static.size = gsize
	Player:load()
	Ubo:load()
	
	local bid = love.image.newImageData(gsize*#self.mapColor,gsize)
	local bsize = math.floor(gsize/3)
	local c = self.mapColor[1]
	for x=0,gsize-1 do
		for y = 0,gsize-1 do
			if x >= bsize and x < (gsize - bsize) and y>=bsize and y <(gsize-bsize) then
				bid:setPixel(x,y,c[1],c[2],c[3],255)
			else
				bid:setPixel(x,y,0,0,0,0)
			end 
		end
	end
	for ic = 2,#self.mapColor do
		c=self.mapColor[ic]
		for x=(ic-1)*gsize,ic*gsize-1 do
			for y=0,gsize-1 do
				bid:setPixel(x,y,c[1],c[2],c[3],255)
			end
		end
	end
	local img = love.graphics.newImage(bid)
	Grid.static.image = img
	
	Grid.static.quads={}
	for i=1,#self.mapColor do
		Grid.static.quads[i] = love.graphics.newQuad((i-1)*gsize,0,gsize,gsize,gsize*#self.mapColor,gsize)
	end
end
	