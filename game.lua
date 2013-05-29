require 'lib/middleclass'
require 'player'
require 'ubo'
require 'grid'
require 'caption'

Stateful= require 'lib/stateful'

Game = class('Game')
Game:include(Stateful)

local Transition = Game:addState('Transition')

function Transition:update(dt)
	self.grid:update(dt)
	self.delay = self.delay - dt
	if self.delay < 0 then
		self.delay = Game.TRANSITION_DELAY
		self.grid:startLevel(self.level)
		self:gotoState(nil)
	end
end

function Transition:draw()
	self.grid:draw()
	self.caption:draw()
end

function Game:initialize()
	self.delay=Game.TRANSITION_DELAY
	self.level=1
	self.grid = Grid(20)
	self.grid:startLevel(self.level)
	self.caption=Caption(Game.font)
end


function Game:draw()
	self.grid:draw()
end

function Game:update(dt)
	self.grid:update(dt)
	if self.grid:isFinished() then
		if self.grid:isSuccess() then
			self.level = self.level + 1
			self.caption:setLines("LEVEL COMPLETED","GO TO NEXT LEVEL")
		else
			self.caption:setLines("LEVEL FAILED",self.grid.event,"RESTART LEVEL")
		end
		self.delay = Game.TRANSITION_DELAY
		self:gotoState('Transition')
	end
end

function Game.static:load(gsize)
	Game.static.font  = love.graphics.newFont(18)
	Game.static.color ={255,255,255}
	Game.static.TRANSITION_DELAY=3
	Grid:load(gsize)	
end