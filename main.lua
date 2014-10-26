function love.load()
   require "setup"

   MENU = 0
   GAME = 1
   END = 2
   
   gameMode = MENU
   players = {}
   powerUps = {}

   loadSounds()
   loadImages()
   
   local fontUrl = "fonts/kenpixel_future_square.ttf"
   fontMini = gr.newFont(fontUrl, 11)
   fontSmall = gr.newFont(fontUrl, 22)
   fontBig = gr.newFont(fontUrl, 48)

   math.randomseed(os.time())
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
      updatePowerUps(dt)
   elseif gameMode == END then
   end
end

function love.draw()
   drawBackground()
   if gameMode == MENU then
      drawTitle()
      drawShips()
      gr.setFont(fontSmall)
      gr.print("Choose your limit", 340, 575)
      gr.setFont(fontMini)
      gr.print("Ship #1: Limited fire rate", 340, 625)
      gr.print("Ship #2: Limited turn rate", 340, 640)
      gr.print("Ship #3: Limited speed", 340, 655)
      gr.print("Ship #0: No play", 340, 670)
   elseif gameMode == GAME then
      for i=1, #players do
	 drawPlayer(players[i])
      end
      
      drawLifebar()
      drawPowerUps()
   elseif gameMode == END then
   end
end

function love.keypressed(key)
   if gameMode == MENU then
      if key == "escape" then
	 love.event.push('quit')
	 return
      elseif key == "return" then
	 players = {}
	 powerUps = {}
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
	 3.5,
	 7.5
      },
      shootingSpeed = {
	 0,
	 2,
	 1,
	 1
      },
      bulletSpeed = function() return 20 end
   }

   numbers = {}
   for i=0, 9 do
      numbers[i] = gr.newImage("images/ui/numeral" .. i .. ".png")
   end
   table.insert(numbers, gr.newImage("images/ui/numeralX.png"))

   powerUpImages = {
      speed = gr.newImage("images/bolt_gold.png"),
      firerate = gr.newImage("images/things_gold.png")      
   }
end

function initPlayers()
   if ships.orange.type ~= 1 then
      table.insert(players,
		   initPlayer("Player 1", ships.orange,
			      100, 100, 90,
			      'left', 'right')
      )
   end
   
   if ships.green.type ~= 1 then
      table.insert(players,
		   initPlayer("Player 2", ships.green,
			      924, 100, 180,
			      'a', 'd')
      )
   end
   
   if ships.blue.type ~= 1 then
      table.insert(players,
		   initPlayer("Player 3", ships.blue,
			      668, 100, 45,
			      'j', 'l',
			      'kp4', 'kp6')
      )
   end
end

function initPlayer(name, ship, x, y, a, left, right, altLeft, altRight)
   return {
      name = name,
      hp = 100,
      image = {
	 ship = ship.ship(),
	 shot = ship.shot(),
	 lifebar = ship.lifebar
      },
      x = x,
      y = y,
      a = a,
      r = 25,
      speed = ship.speed(),
      rotationSpeed = ship.rotation(),
      shot = {
	 rate = ship.shooting(),
	 time = 0,
	 speed = shipOptions.bulletSpeed(),
	 bullets = {}
      },
      controller = {
	 left = left,
	 altLeft = altLeft,
	 right = right,
	 altRight = altRight
      },
      blink = {
	 on = false,
	 timer = 0,
	 blink = false,
	 duration = 0
      },
      powerUps = {
	 speed = {
	    timer = 0,
	    duration = 2,
	    on = false
	 },
	 firerate = {
	    timer = 0,
	    duration = 2,
	    on = false
	 }
      }
   }
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
   gr.setFont(fontBig)
   gr.print("Little Big Spaceship", 
	    100, 
	    100)
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

function drawPowerUps()
   for k, v in pairs(powerUps) do
      gr.push()
      gr.translate(v.x, v.y)
      gr.rotate(v.a)
      gr.draw(v.image,
	      -v.image:getWidth() / 2,
	      -v.image:getHeight() / 2
      )

      if debug then
	 gr.circle("line", 0, 0, v.r, 100)
      end
      gr.pop()
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
   if player.blink.blink then
      gr.setColor(255, 255, 255, 0)
   end
   gr.draw(image.ship,
	      -image.ship:getWidth() / 4,
	      -image.ship:getHeight() / 4,
	   0,
	   .5,
	   .5
   )
   gr.setColor(255, 255, 255, 255)
   if debug then
      gr.circle("line", 0, 0, player.r, 100)
   end
   gr.pop()
end

function updatePlayer(dt, player)
   -- movement
   local speed = player.speed
   if player.powerUps.speed.on then
      speed = speed * 2
   end
   
   player.x = player.x + (math.sin(player.a) * dt * speed)
   player.y = player.y + -(math.cos(player.a) * dt * speed)
   
   wrapScreen(player)
   
   for i=1, #player.shot.bullets do
      updateShot(dt,
		 player.shot.bullets[i])
   end

   -- blinking
   if player.blink.on then
      player.blink.timer = player.blink.timer + dt
      player.blink.duration = player.blink.duration + dt
      if player.blink.timer > .064 then
	 player.blink.blink = true
	 player.blink.timer = 0
      else
	 player.blink.blink = false
      end

      if player.blink.duration > .5 then
	 player.blink.duration = 0
	 player.blink.on = false
	 player.blink.blink = false
      end
   end

   -- power ups
   if player.powerUps.speed.on then
      updatePowerUp(dt, player.powerUps.speed)
   end
   if player.powerUps.firerate.on then
      updatePowerUp(dt, player.powerUps.firerate)
   end

   -- check if dead
   if player.hp <= 0 then
      player.image.ship = ships.orange.shipImages[1]
      return
   end

   -- rotation
   if player.toggleLeft then
      player.a = player.a - (dt * player.rotationSpeed)
   end
   
   if player.toggleRight then
      player.a = player.a + (dt * player.rotationSpeed)
   end

   -- shooting
   player.shot.time = player.shot.time + dt

   local firerate = player.shot.rate
   if player.powerUps.firerate.on then
      firerate = firerate / 8
   end

   if player.shot.time > firerate then
      if #player.shot.bullets < 100 then
	 table.insert(player.shot.bullets,
		      { 
			 x = player.x + (math.sin(player.a) * 40),
			 y = player.y + -(math.cos(player.a) * 40),
			 a = player.a,
			 damage = 10,
			 r = 15,
			 speed = speed + player.shot.speed
		      }
	 )
	 au.play(sounds.laser)
      end
      player.shot.time = player.shot.time - firerate
   end
end

function updatePowerUp(dt, up)
   up.timer = up.timer + dt
   
   if up.timer > up.duration then
      up.on = false
      up.timer = 0
   end
end

function updateShot(dt, shot)
   shot.x = shot.x + (math.sin(shot.a) * dt * shot.speed)
   shot.y = shot.y + -(math.cos(shot.a) * dt * shot.speed)

   wrapScreen(shot)
end

-- hit detection
function updateShooting(dt, currentPlayer)
   local survivingBullets = {}
   
   for b=1, #currentPlayer.shot.bullets do
      local shot = currentPlayer.shot.bullets[b]
      local surviving = true
      
      for p=1, #players do
	 local player = players[p]
	 local dist = dist(player.x, player.y, shot.x, shot.y)
	 
	 if dist < player.r + (shot.r / 2) then
	       player.hp = player.hp - shot.damage
	       player.blink.on = true
	       au.play(sounds.hit)
	       surviving = false
	 end
      end
      
      if surviving then
	 -- not really efficient at all!
	 table.insert(survivingBullets, shot)
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

function updatePowerUps(dt)
   if #powerUps == 0 then
      local switch = math.random(1, 2)
      local up = {}
      if switch == 1 then
	 up = {
	    x = math.random(50, 974),
	    y = math.random(50, 718),
	    a = 0,
	    r = 12,
	    image = powerUpImages.speed,
	    type = 'speed'
	 }
      else
	 up = {
	    x = math.random(50, 974),
	    y = math.random(50, 718),
	    a = 0,
	    r = 12,
	    image = powerUpImages.firerate,
	    type = 'firerate' 
	 }
      end
      table.insert(powerUps, up)
   end

   for k,v in pairs(powerUps) do
      v.a = v.a + dt

      -- hit detection
      for pk, pv in pairs(players) do
	 local dist = dist(v.x, v.y, pv.x, pv.y)
	 
	 if dist < pv.r + (v.r / 2) then
	    if v.type == 'speed' then
	       pv.powerUps.speed.timer = 0
	       pv.powerUps.speed.on = true
	       table.remove(powerUps, k)
	    elseif v.type == 'firerate' then
	       pv.powerUps.firerate.timer = 0
	       pv.powerUps.firerate.on = true
	       table.remove(powerUps, k)
	    end
	 end
      end
   end
end
