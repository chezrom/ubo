Caption = Mobile:subclass('Caption')

Caption.static.color   = {255,255,255}
Caption.static.activeColor = {255,255,0}
Caption.static.bgColor     = {128,128,128,128}

function Caption:initialize(font)

	self.font=font
	self:setLines()

end

function Caption:setLines(tbl)
	if not tbl then
		self.lines={}
	else
		self.lines=tbl
	end
	if #self.lines == 0  then
		self.h = self.font:getHeight()
		self.w = 100
	else
		self.w = 100
		self.h = (1 + 2*#self.lines) * self.font:getHeight() 
		for i=1,#self.lines do
			local wl = self.font:getWidth(self.lines[i]) + 50
			if wl > self.w then
				self.w = wl
			end
		end
	end
	
	self:center()

	self.active=0
	self.selected=0
end

function Caption:center()
	self.x = math.floor((love.graphics.getWidth()- self.w)/2)
	self.y = math.floor((love.graphics.getHeight() - self.h)/2)
end

function Caption:setMenuMode(menuMode) 
	if menuMode then
		self.active=1
		self.selected=0
	else
		self.active=0
		self.selected=0
	end
end

function Caption:draw()
	love.graphics.setColor(Caption.bgColor)
	love.graphics.rectangle('fill',self.x,self.y,self.w,self.h)
	love.graphics.setFont(self.font)
	for i,text in ipairs(self.lines) do
		if self.active == i then
			love.graphics.setColor(Caption.activeColor)
		else
			love.graphics.setColor(Caption.color)
		end
		love.graphics.printf(text,self.x,self.y + (2*i-1) * self.font:getHeight(),self.w,"center")	
	end
end

function Caption:keypressed(key)
	if self.selected == 0 then
		if key == "up" then
			self.active = self.active - 1
			if self.active < 1 then
				self.active=#self.lines
			end
		elseif key == "down" then
			self.active = self.active + 1
			if self.active > #self.lines then
				self.active=1
			end
		elseif key == " " or key == "return" then
			self.selected = self.active
		end
	end
end
