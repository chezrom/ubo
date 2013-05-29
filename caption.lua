Caption = Mobile:subclass('Caption')

Caption.static.color   = {255,255,255}
Caption.static.bgColor     = {0,0,256,196}

function Caption:initialize(font)

	self.font=font
	--self:setLines()
	self:setLines("ZORG 2013 WORLD PARADIGM CHAMPIONSHIP -- SYNERGIE EDITION","OMGWTFBBQ ??? OH YEAH!!!")


end

function Caption:setLines(...)
	self.lines={...}
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
	
	self.x = math.floor((love.graphics.getWidth()- self.w)/2)
	self.y = math.floor((love.graphics.getHeight() - self.h)/2)

end

function Caption:draw()
	love.graphics.setColor(Caption.bgColor)
	love.graphics.rectangle('fill',self.x,self.y,self.w,self.h)
	love.graphics.setColor(Caption.color)
	love.graphics.setFont(self.font)
	for i,text in ipairs(self.lines) do
		love.graphics.printf(text,self.x,self.y + (2*i-1) * self.font:getHeight(),self.w,"center")	
	end
end
