function love.load()
   require "setup"

   MENU = 0
   GAME = 1
   END = 2
   
   gameMode = MENU
   players = {}
   ships = {}

   loadSounds()
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
	 updateShooting(dt, players[i])
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
      elseif key == 'f9' then
	 debug = not debug
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
	 if ships.orange.type > 4 then
	    ships.orange.type = 1
	 end
      end
      if key == 'a' then
	 ships.green.type = ships.green.type - 1
	 if ships.green.type < 1 then
	    ships.green.type = 4
	 end
      end
      if key == 'd' then
	 ships.green.type = ships.green.type + 1
	 if ships.green.type > 4 then
	    ships.green.type = 1
	 end
      end
      if key == 'j' or key == 'kp4' then
	 ships.blue.type = ships.blue.type - 1
	 if ships.blue.type < 1 then
	    ships.blue.type = 4
	 end
      end
      if key == 'l' or key == 'kp6' then
	 ships.blue.type = ships.blue.type + 1
	 if ships.blue.type > 4 then
	    ships.blue.type = 1
	 end
      end

   elseif gameMode == GAME then
      if key == "escape" then
	 gameMode = MENU
	 return
      elseif key == 'f9' then
	 debug = not debug
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

function loadSounds()
   sounds = {
      laser = au.newSource("sounds/laser01.mp3"),
      hit = au.newSource("sounds/explosion3.mp3")
   }

end

function loadImages()
   background = {
      gr.newImage("images/blue.png"),
      gr.newImage("images/purple.png")
   }

   ships = { 
      green = {
	 ship = function() return ships.green.shipImages[ships.green.type] end,
	 shot = function() return ships.green.shotImages[1] end,
	 speed = function() return shipOptions.speeds[ships.green.type] end,
	 rotation = function() return shipOptions.rotationSpeeds[ships.green.type] end,
	 shooting = function() return shipOptions.shootingSpeed[ships.green.type] end,
	 shipImages = {
	    gr.newImage("images/ships/playerShip1_damage3.png"),
	    gr.newImage("images/ships/playerShip1_green.png"),
	    gr.newImage("images/ships/playerShip2_green.png"),
	    gr.newImage("images/ships/playerShip3_green.png")
	 },
	 shotImages = {
	    gr.newImage("images/laserGreen13.png")
	 },
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
	 ship = function() return ships.blue.shipImages[ships.blue.type] end,
	 shot = function() return ships.blue.shotImages[1] end,
	 speed = function() return shipOptions.speeds[ships.blue.type] end,
	 rotation = function() return shipOptions.rotationSpeeds[ships.blue.type] end,
	 shooting = function() return shipOptions.shootingSpeed[ships.blue.type] end,
	 shipImages = {
	    gr.newImage("images/ships/playerShip1_damage3.png"),
	    gr.newImage("images/ships/playerShip1_blue.png"),
	    gr.newImage("images/ships/playerShip2_blue.png"),
	    gr.newImage("images/ships/playerShip3_blue.png")
	 },
	 shotImages = {
	    gr.newImage("images/laserBlue07.png")
	 },
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
	 ship = function() return ships.orange.shipImages[ships.orange.type] end,
	 shot = function() return ships.orange.shotImages[1] end,
	 speed = function() return shipOptions.speeds[ships.orange.type] end,
	 rotation = function() return shipOptions.rotationSpeeds[ships.orange.type] end,
	 shooting = function() return shipOptions.shootingSpeed[ships.orange.type] end,
	 shipImages = {
	    gr.newImage("images/ships/playerShip1_damage3.png"),
	    gr.newImage("images/ships/playerShip1_orange.png"),
	    gr.newImage("images/ships/playerShip2_orange.png"),
	    gr.newImage("images/ships/playerShip3_orange.png")
	 },
	 shotImages = {
	    gr.newImage("images/laserRed07.png")
	 },
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

   shipOptions = {
      speeds = {
	 10,
	 400,
	 400,
	 200
      },
      rotationSpeeds = {
	 0,
	 7.5,
	 5.5,
	 7.5
      },
      shootingSpeed = {
	 0,
	 2,
	 1,
	 1
      }
   }

   numbers = {}
   for i=0, 9 do
      numbers[i] = gr.newImage("images/ui/numeral" .. i .. ".png")
   end
   table.insert(numbers, gr.newImage("images/ui/numeralX.png"))
end

function initPlayers()
   players = {}
   if ships.orange.type ~= 1 then
      table.insert(players, 
		   {
		      name = "Player 1",
		      hp = 100,
		      image = {
			 ship = ships.orange.ship(),
			 shot = ships.orange.shot(),
			 lifebar = ships.orange.lifebar
		      },
		      x = 100,
		      y = 100,
		      a = 90,
		      r = 25,
		      speed = ships.orange.speed(),
		      rotationSpeed = ships.orange.rotation(),
		      shot = {
			 rate = ships.orange.shooting(),
			 time = 0,
			 speed = 500,
			 bullets = {}
		      },
		      controller = {
			 left = 'left',
			 right = 'right'
		      },
		      blink = false,
		      blinkTimer = 0
		   }
      )
      local i = #players
   end
      
   if ships.green.type ~= 1 then
      table.insert(players, 
		   {
		      name = "Player 2",
		      hp = 100,
		      image = {
			 ship = ships.green.ship(),
			 shot = ships.green.shot(),
			 lifebar = ships.green.lifebar
		      },
		      x = 924,
		      y = 100,
		      a = 180,
		      r = 25,
		      speed = ships.green.speed(),
		      rotationSpeed = ships.green.rotation(),
		      shot = {
			 rate = ships.green.shooting(),
			 time = 0,
			 speed = 500,
			 bullets = {}
		      },
		      controller = {
			 left = 'a',
			 right = 'd'
		      }
		   }
      )
      local i = #players
   end
   
   if ships.blue.type ~= 1 then
      table.insert(players, 
		   {
		      name = "Player 3",
		      hp = 100,
		      image = {
			 ship = ships.blue.ship(),
			 shot = ships.blue.shot(),
			 lifebar = ships.blue.lifebar
		      },
		      x = 100,
		      y = 668,
		      a = 45,
		      r = 25,
		      speed = ships.blue.speed(),
		      rotationSpeed = ships.blue.rotation(),
		      shot = {
			 rate = ships.blue.shooting(),
			 time = 0,
			 speed = 500,
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
      local ship = v.ship()
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
      
      if players[i].hp > 0 then
	 local hp = tostring(players[i].hp)
	 while #hp < 3 do 
	    hp = "0" .. hp
	 end
	 
	 for j=1, #hp do
	    local n = tonumber(hp:sub(j, j))
	    gr.draw(numbers[n],
		    lifebar.textX + (numbers[0]:getWidth() * j),
		    lifebar.y - 10)
	 end
      else
	 for j=1, 3 do
	    gr.draw(numbers[10],
		    lifebar.textX + (numbers[0]:getWidth() * j),
		    lifebar.y - 10)
	 end
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
   -- movement
   player.x = player.x + (math.sin(player.a) * dt * player.speed)
   player.y = player.y + -(math.cos(player.a) * dt * player.speed)
   
   wrapScreen(player)
   
   for i=1, #player.shot.bullets do
      updateShot(dt, player.shot.bullets[i], player.shot.speed)
   end
  
   -- check if dead
   if player.hp <= 0 then
      player.image.ship = ships.orange.shipImages[1]
      return
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
	 au.play(sounds.laser)
      end
      player.shot.time = player.shot.time - player.shot.rate
   end
   -- rotation
   if player.toggleLeft then
      player.a = player.a - (dt * player.rotationSpeed)
   end
   
   if player.toggleRight then
      player.a = player.a + (dt * player.rotationSpeed)
   end
end

function updateShot(dt, shot, speed)
   shot.x = shot.x + (math.sin(shot.a) * dt * speed)
   shot.y = shot.y + -(math.cos(shot.a) * dt * speed)

   wrapScreen(shot)
end

-- hit detection
function updateShooting(dt, currentPlayer)
   local survivingBullets = {}
   
   for b=1, #currentPlayer.shot.bullets do
      local shot = currentPlayer.shot.bullets[b]
      
      for p=1, #players do
	 local player = players[p]
	 local dist = dist(player.x, player.y, shot.x, shot.y)
	 
	 if dist < player.r + (shot.r / 2) then
	       player.hp = player.hp - shot.damage
	       player.blink = true
	       au.play(sounds.hit)
	 else
	    -- not really efficient at all!
	    table.insert(survivingBullets, shot)
	 end
      end
   end
   
   currentPlayer.shot.bullets = survivingBullets
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
