require 'game'

function love.load()
	--love.mouse.setVisible(false)
	Game:load(12)
	game = Game()
end

function love.draw() 
	game:draw()
end


function love.update(dt)
	game:update(dt)
end


function game_update(self,dt)

	--[[
	grid:update(dt)
	if grid:isFinished() then
		if grid:isSuccess() then
			level = level + 1
		end
		loose("***")
	end
	--]]
	--[[
	for iq = 1, #qixes do
		local qix = qixes[iq]
		if map[qix.y][qix.x] == 1 or (qix.x == player.x and qix.y == player.y) then
				loose("YOU HIT A QIX, RESTART LEVEL")
				return
		end
	end
	--]]
end

function love.mousepressed(x,y,b)
	game:mousepressed(x,y,b)
end

function love.keypressed(key)
	game:keypressed(key)
end
