require 'lib/middleclass'
require 'player'
require 'ubo'
require 'grid'

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

function Game:initialize()
	self.delay=Game.TRANSITION_DELAY
	self.level=1
	self.grid = Grid(20)
	self.grid:startLevel(self.level)	
end


function Game:draw()

	love.graphics.setColor(120,120,120)
	love.graphics.rectangle('fill',0,0,love.graphics.getWidth(),self.grid.start_y)
	
	love.graphics.setFont(Game.font)
	love.graphics.setColor(Game.color)
	love.graphics.print(string.format('LEVEL %2d : %2d %% FILLED',self.grid.level,self.grid.percent),20,0)

	self.grid:draw()

end

function Game:update(dt)
	self.grid:update(dt)
	if self.grid:isFinished() then
		if self.grid:isSuccess() then
			self.level = self.level + 1
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