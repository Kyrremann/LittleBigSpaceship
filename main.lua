function love.load()
   require "setup"

   MENU = 0
   GAME = 1
   END = 2
   
   gameMode = MENU
   players = {}
   ships = {}

   loadImages()

   players[1] = {
      name = "Player 1",
      hp = 100,
      image = nil,
      x = 100,
      y = 100,
      a = 90,
      r = 25,
      speed = 200,
      rotationSpeed = 7.5,
      shot = {
	 rate = 1,
	 time = 0,
	 speed = 400,
	 bullets = {}
      }
   }
   players[1].image = ships[1]
--[[   
   players[2] = {
      name = "Player 1",
      hp = 100,
      image = nil,
      x = 924,
      y = 668,
      a = -45,
      r = 25,
      speed = 500,
      rotationSpeed = 7.5,
      shot = {
	 rate = 1,
	 time = 0,
	 damage = 10,
	 speed = 800,
	 r = 15,
	 bullets = {}
      }
   }
   players[2].image = ships[2]
]]
end

function love.update(dt)
   if gameMode == MENU then
      for i=1, #ships do
	 ships[i].r = ships[i].r + (dt * 1)
      end
   elseif gameMode == GAME then
      for i=1, #players do
	 updatePlayer(dt, players[i])
      end
   elseif gameMode == END then
   end
end

function love.draw()
   drawBackground()
   if gameMode == MENU then
      drawTitle()
      drawShips()
   elseif gameMode == GAME then
      for i=1, #players do
	 drawPlayer(players[i])
      end
      
      drawLifebar()
   elseif gameMode == END then
   end
end

function love.keypressed(key)
   if gameMode == MENU then
      if key == "escape" then
	 love.event.push('quit')
      end
   elseif gameMode == GAME then
      if key == "escape" then
	 gameMode = MENU
      end
      
      if key == 'a' then
	 players[1].toggleLeft = true
      end
      
      if key == 'd' then
	 players[1].toggleRight = true
      end
      
      if #players < 2 then return end
      
      if key == 'left' then
	 players[2].toggleLeft = true
      end
      
      if key == 'right' then
	 players[2].toggleRight = true
      end
      
      if #players < 3 then return end
   elseif gameMode == END then
   end
end

function love.keyreleased(key)
   if gameMode == MENU then
   elseif gameMode == GAME then
      if key == 'a' then
	 players[1].toggleLeft = false
      end
      
      if key == 'd' then
	 players[1].toggleRight = false
      end
      
      if #players < 2 then return end
      
      if key == 'left' then
	 players[2].toggleLeft = false
      end
      
      if key == 'right' then
	 players[2].toggleRight = false
      end
      
      if #players < 3 then return end
   elseif gameMode == END then
   end
end

function loadImages()
   background = {
      gr.newImage("images/blue.png"),
      gr.newImage("images/purple.png")
   }
   ships = { 
      {
	 ship = gr.newImage("images/playerShip3_green.png"),
	 shot = gr.newImage("images/laserGreen13.png"),
	 r = math.random(360)
      },
      {
	 ship = gr.newImage("images/playerShip1_blue.png"),
	 shot = gr.newImage("images/laserBlue07.png"),
	 r = math.random(360)
      },
      {
	 ship = gr.newImage("images/playerShip2_orange.png"),
	 shot = gr.newImage("images/laserRed07.png"),
	 r = math.random(360)
      },
      {
	 ship = gr.newImage("images/playerShip1_red.png"),
	 shot = gr.newImage("images/laserRed07.png"),
	 r = math.random(360)
      }
   }

   lifebar = {
      green = gr.newImage("images/ui/playerLife3_green.png")
   }

   numbers = {}
   for i=0, 9 do
      numbers[i] = gr.newImage("images/ui/numeral" .. i .. ".png")
   end
   table.insert(numbers, gr.newImage("images/ui/numeralX.png"))
end

function drawBackground()
   for x=0, gr.getWidth() / 256 do
      for y=0, gr.getHeight() / 256 do
	 if gameMode == MENU then
	    gr.draw(background[1], x * 256, y * 256)
	 elseif gameMode == GAME then
	    gr.draw(background[2], x * 256, y * 256)
	 elseif gameMode == END then
	 end
      end
   end
end

function drawTitle()
   gr.print("Little Big Spaceship", 
	    200, 
	    100,
	    0,
	    5,
	    5)
end

function drawShips()
   for i=1, #ships do
      gr.push()
      gr.translate(120 + (i * 150), 500)
      gr.rotate(ships[i].r)
      gr.draw(ships[i].ship,
		 -ships[i].ship:getWidth() / 2,
		 -ships[i].ship:getHeight() / 2)
      gr.pop()
   end
end

function drawLifebar()
   gr.draw(lifebar.green, 10, 10)
   local hp = tostring(players[1].hp)
   
   for i = 1, #hp do
      local n = tonumber(hp:sub(i,i))
      gr.draw(numbers[n],
	      lifebar.green:getWidth() + (15 * i),
	      10)
   end
end

function drawPlayer(player)
   local image = player.image
      
   for i=1, #player.shot.bullets do
      gr.push()
      local shot = player.shot.bullets[i]
      gr.translate(shot.x, shot.y)
      gr.rotate(shot.a)
      gr.draw(image.shot,
		 -image.shot:getWidth() / 2,
		 -image.shot:getHeight() / 2
      )
      if debug then
	 gr.circle("line",
		   0,
		   0,
		   shot.r,
		   100)
      end
      gr.pop()
   end

   gr.push()
   gr.translate(player.x, player.y)
   gr.rotate(player.a)
   gr.draw(image.ship,
	      -image.ship:getWidth() / 4,
	      -image.ship:getHeight() / 4,
	   0,
	   .5,
	   .5
   )
   if debug then
      gr.circle("line", 0, 0, player.r, 100)
   end
   gr.pop()
end

function updatePlayer(dt, player)
   -- rotation
   if player.toggleLeft then
      player.a = player.a - (dt * player.rotationSpeed)
   end
   
   if player.toggleRight then
      player.a = player.a + (dt * player.rotationSpeed)
   end

   -- movement
   player.x = player.x + (math.sin(player.a) * dt * player.speed)
   player.y = player.y + -(math.cos(player.a) * dt * player.speed)
   
   wrapScreen(player)
   
   for i=1, #player.shot.bullets do
      updateShot(dt, player.shot.bullets[i], player.shot.speed)
   end

   -- hit detection
   for p=1, #players do
      local player = players[p]
      local survivingBullets = {}
      local counter = 1

      for i=1, #player.shot.bullets do
	 local shot = player.shot.bullets[i]
	 local dist = dist(player.x, player.y, shot.x, shot.y)
	 
	 if dist < player.r + shot.r then
	    player.hp = player.hp - shot.damage
	 else
	    -- not really efficient at all!
	    table.insert(survivingBullets, shot)
	 end
      end
      player.shot.bullets = survivingBullets
   end
   
   -- shooting
   player.shot.time = player.shot.time + dt

   if player.shot.time > player.shot.rate then
      if #player.shot.bullets < 5 then
	 table.insert(player.shot.bullets,
		      { 
			 x = player.x + (math.sin(player.a) * 40),
			 y = player.y + -(math.cos(player.a) * 40),
			 a = player.a,
			 damage = 10,
			 r = 15
		      }
	 )
      end
      player.shot.time = player.shot.time - player.shot.rate
   end
end

function updateShot(dt, shot, speed)
   shot.x = shot.x + (math.sin(shot.a) * dt * speed)
   shot.y = shot.y + -(math.cos(shot.a) * dt * speed)

   wrapScreen(shot)
end

function dist(x1,y1, x2,y2)
   return ((x2-x1)^2+(y2-y1)^2)^0.5
end

function wrapScreen(obj)
   if obj.x > gr.getWidth() then
      obj.x = obj.x - gr.getWidth()
   end

   if obj.x < 0 then
      obj.x = obj.x + gr.getWidth()
   end
   
   if obj.y > gr.getHeight() then
      obj.y = obj.y - gr.getHeight()
   end

   if obj.y < 0 then
      obj.y = obj.y + gr.getHeight()
   end
end
