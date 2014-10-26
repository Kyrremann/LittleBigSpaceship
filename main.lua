function love.load()
   require "setup"

   MENU = 0
   GAME = 1
   END = 2
   
   gameMode = MENU
   players = {}
   ships = {}

   loadImages()
end

function love.update(dt)
   if gameMode == MENU then
      for k, v in pairs(ships) do
	 v.r = v.r + (dt * 1)
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
      gr.print("Choose your limit",
	       420,
	       575,
	       0,
	       1.5,
	       1.5)
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
	 return
      elseif key == "return" then
	 initPlayers()
	 gameMode = GAME
	 return
      end   
      if key == 'left' then
	 ships.orange.type = ships.orange.type - 1
	 if ships.orange.type <= 0 then
	    ships.orange.type = 4
	 end
      end
      if key == 'right' then
	 ships.orange.type = ships.orange.type + 1
	 if ships.orange.type >= 4 then
	    ships.orange.type = 1
	 end
      end
      if key == 'a' then
	 ships.green.type = ships.green.type - 1
	 if ships.green.type <= 0 then
	    ships.green.type = 4
	 end
      end
      if key == 'd' then
	 ships.green.type = ships.green.type + 1
	 if ships.green.type >= 4 then
	    ships.green.type = 1
	 end
      end
      if key == 'j' or key == 'kp4' then
	 ships.blue.type = ships.blue.type - 1
	 if ships.blue.type <= 0 then
	    ships.blue.type = 4
	 end
      end
      if key == 'l' or key == 'kp6' then
	 ships.blue.type = ships.blue.type + 1
	 if ships.blue.type >= 4 then
	    ships.blue.type = 1
	 end
      end
   elseif gameMode == GAME then
      if key == "escape" then
	 gameMode = MENU
	 return
      end
      if key == 'left' then
	 players[1].toggleLeft = true
      end
      if key == 'right' then
	 players[1].toggleRight = true
      end
      if #players < 2 then return end
      if key == 'a' then
	 players[2].toggleLeft = true
      end
      if key == 'd' then
	 players[2].toggleRight = true
      end
      if #players < 3 then return end
      if key == 'j' or key == 'kp4' then
	 players[3].toggleLeft = true
      end
      if key == 'l' or key == 'kp6' then
	 players[3].toggleRight = true
      end
   elseif gameMode == END then
   end
end

function love.keyreleased(key)
   if gameMode == MENU then
   elseif gameMode == GAME then
      if key == 'left' then
	 players[1].toggleLeft = false
      end      
      if key == 'right' then
	 players[1].toggleRight = false
      end
      if #players < 2 then return end
      if key == 'a' then
	 players[2].toggleLeft = false
      end
      if key == 'd' then
	 players[2].toggleRight = false
      end
      if #players < 3 then return end
      if key == 'j' or key == 'kp4' then
	 players[3].toggleLeft = false
      end
      if key == 'l' or key == 'kp6' then
	 players[3].toggleRight = false
      end
   elseif gameMode == END then
   end
end

function loadImages()
   background = {
      gr.newImage("images/blue.png"),
      gr.newImage("images/purple.png")
   }
   ships = { 
      green = {
	 ship = {
	    gr.newImage("images/ships/playerShip1_damage3.png"),
	    gr.newImage("images/ships/playerShip1_green.png"),
	    gr.newImage("images/ships/playerShip2_green.png"),
	    gr.newImage("images/ships/playerShip3_green.png")
	 },
	 shot = gr.newImage("images/laserGreen13.png"),
	 r = math.random(360),
	 type = 1,
	 lifebar = {
	    image = gr.newImage("images/ui/playerLife3_green.png"),
	    textX = gr.getWidth() - 120,
	    x = gr.getWidth() - 25,
	    y = 25
	 }
      },

      blue = {
	 ship = {
	    gr.newImage("images/ships/playerShip1_damage3.png"),
	    gr.newImage("images/ships/playerShip1_blue.png"),
	    gr.newImage("images/ships/playerShip2_blue.png"),
	    gr.newImage("images/ships/playerShip3_blue.png")
	 },
	 shot = gr.newImage("images/laserBlue07.png"),
	 r = math.random(360),
	 type = 1,
	 lifebar = {
	    image = gr.newImage("images/ui/playerLife3_blue.png"),
	    textX = 25,
	    x = 25,
	    y = gr.getHeight() - 25
	 }
      },

      orange = {
	 ship = {
	    gr.newImage("images/ships/playerShip1_damage3.png"),
	    gr.newImage("images/ships/playerShip1_orange.png"),
	    gr.newImage("images/ships/playerShip2_orange.png"),
	    gr.newImage("images/ships/playerShip3_orange.png")
	 },
	 shot = gr.newImage("images/laserRed07.png"),
	 r = math.random(360),
	 type = 2,
	 lifebar = {
	    image = gr.newImage("images/ui/playerLife3_orange.png"),
	    textX = 25,
	    x = 25,
	    y = 25
	 }
      }
   }

   numbers = {}
   for i=0, 9 do
      numbers[i] = gr.newImage("images/ui/numeral" .. i .. ".png")
   end
   table.insert(numbers, gr.newImage("images/ui/numeralX.png"))
end

function initPlayers()
   if ships.orange.type ~= 1 then
      table.insert(players, 
		   {
		      name = "Player 1",
		      hp = 100,
		      image = ships.orange,
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
		      },
		      controller = {
			 left = 'left',
			 right = 'right'
		      }
		   }
      )
      local i = #players
      players[i].image.ship = players[i].image.ship[players[i].image.type]
   end
      
   if ships.green.type ~= 1 then
      table.insert(players, 
		   {
		      name = "Player 2",
		      hp = 100,
		      image = ships.green,
		      x = 924,
		      y = 100,
		      a = 180,
		      r = 25,
		      speed = 200,
		      rotationSpeed = 7.5,
		      shot = {
			 rate = 1,
			 time = 0,
			 speed = 400,
			 bullets = {}
		      },
		      controller = {
			 left = 'a',
			 right = 'd'
		      }
		   }
      )
      local i = #players
      players[i].image.ship = players[i].image.ship[players[i].image.type]
   end
   
   if ships.blue.type ~= 1 then
      table.insert(players, 
		   {
		      name = "Player 3",
		      hp = 100,
		      image = ships.blue,
		      x = 100,
		      y = 668,
		      a = 45,
		      r = 25,
		      speed = 200,
		      rotationSpeed = 7.5,
		      shot = {
			 rate = 1,
			 time = 0,
			 speed = 400,
			 bullets = {}
		      },
		      controller = {
			 left = 'j',
			 altLeft = 'kp4',
			 right = 'l',
			 altRight = 'kp6'
		      }
		   }
      )
      local i = #players
      players[i].image.ship = players[i].image.ship[players[i].image.type]
   end
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
   local i = 1
   for k, v in pairs(ships) do
      local ship = v.ship[v.type]
      gr.push()
      gr.translate(200 + (i * 150), 500)
      gr.rotate(v.r)
      gr.draw(ship,
		 -ship:getWidth() / 2,
		 -ship:getHeight() / 2)
      gr.pop()
      i = i + 1
   end
end

function drawLifebar()
   for i=1, #players do
      local lifebar = players[i].image.lifebar
      local ship = players[i].image.ship
      gr.push()
      gr.translate(lifebar.x, lifebar.y)
      gr.rotate(players[i].a)
      gr.draw(ship,
		 -ship:getWidth() / 8,
		 -ship:getHeight() / 8,
	      0,
	      .25,
	      .25)
      gr.pop()

      local hp = tostring(players[1].hp)      
      for i = 1, #hp do
	 local n = tonumber(hp:sub(i,i))
	 gr.draw(numbers[n],
		 lifebar.textX + (numbers[0]:getWidth() * i),
		 lifebar.y - 10)
      end
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
