function love.load()
	
	--Declarando o mundo do jogo (sem gravidade)
	love.physics.setMeter(64)
	world = love.physics.newWorld(0, 0, true)
	world:setCallbacks(beginContact)
	
	score = 0
	record = 0
	
	objects = {}
	
	--Parede da esquerda
	objects.wallLeft = {}
	objects.wallLeft.body = love.physics.newBody(world, 5, love.graphics.getHeight()/2)
	objects.wallLeft.shape = love.physics.newRectangleShape(10, love.graphics.getHeight())
	objects.wallLeft.fixture = love.physics.newFixture(objects.wallLeft.body, objects.wallLeft.shape)
	objects.wallLeft.fixture:setFriction(0)
	
	--Parede da direita
	objects.wallRight = {}
	objects.wallRight.body = love.physics.newBody(world, love.graphics.getWidth()-5, love.graphics.getHeight()/2)
	objects.wallRight.shape = love.physics.newRectangleShape(10, love.graphics.getHeight())
	objects.wallRight.fixture = love.physics.newFixture(objects.wallRight.body, objects.wallRight.shape)
	objects.wallRight.fixture:setFriction(0)
	
	--Teto
	objects.roof = {}
	objects.roof.body = love.physics.newBody(world, love.graphics.getWidth()/2, 5)
	objects.roof.shape = love.physics.newRectangleShape(love.graphics.getWidth(), 10)
	objects.roof.fixture = love.physics.newFixture(objects.roof.body, objects.roof.shape)
	objects.roof.fixture:setFriction(0)
	
	--Bola
	objects.ball = {}
	objects.ball.body = love.physics.newBody(world, love.graphics.getWidth()/2, 20, "dynamic")
	objects.ball.shape = love.physics.newCircleShape(10)
	objects.ball.fixture = love.physics.newFixture(objects.ball.body, objects.ball.shape)
	objects.ball.body:setLinearVelocity(0, 900)
	objects.ball.fixture:setRestitution(1.005)
	objects.ball.fixture:setFriction(0)
	objects.ball.fixture:setUserData("Ball")

	--Plataforma no chão
	objects.polygon = {}
	objects.polygon.body = love.physics.newBody(world, love.graphics.getWidth()/2, love.graphics.getHeight()-7.5)
	objects.polygon.shape = love.physics.newPolygonShape(-75, -4, 1, -15, 75, -4, -75, 7.5, 75, 7.5)
	objects.polygon.fixture = love.physics.newFixture(objects.polygon.body, objects.polygon.shape)
	objects.polygon.fixture:setFriction(0)
	objects.polygon.fixture:setUserData("Floor")
	
end

function love.update(dt)

	world:update(dt)
	
	--Movendo a plataforma
	if love.keyboard.isDown("right") then
		objects.polygon.body:setPosition(objects.polygon.body:getX() + 15, love.graphics.getHeight()-7.5)
	elseif love.keyboard.isDown("left") then
		objects.polygon.body:setPosition(objects.polygon.body:getX() - 15, love.graphics.getHeight()-7.5)
	end
	
	--Limitando a plataforma até as paredes
	if objects.polygon.body:getX() < 86 then
		objects.polygon.body:setX(86)
	elseif objects.polygon.body:getX() > love.graphics.getWidth()-86 then
		objects.polygon.body:setX(love.graphics.getWidth()-86)
	end

	--Reiniciando o jogo
	if objects.ball.body:getY() > love.graphics.getHeight() then
		if score > record then
			record = score
		end
		score = 0
		objects.polygon.body:setPosition(love.graphics.getWidth()/2, love.graphics.getHeight()-7.5)
		objects.ball.body:setPosition(love.graphics.getWidth()/2, 20)
		objects.ball.body:setLinearVelocity(0, 900)
	end

end

function love.draw()

	--Desenhando a plataforma
	love.graphics.setColor(215, 60, 130)
	love.graphics.polygon("fill", objects.polygon.body:getWorldPoints(objects.polygon.shape:getPoints()))
	
	--Desenhando a Bola
	love.graphics.setColor(255, 255, 255)
	love.graphics.circle("fill", objects.ball.body:getX(), objects.ball.body:getY(), objects.ball.shape:getRadius())

	--Desenhando o teto e as paredes
	love.graphics.setColor(102, 204, 0)
	love.graphics.polygon("fill", objects.roof.body:getWorldPoints(objects.roof.shape:getPoints()))
	love.graphics.polygon("fill", objects.wallLeft.body:getWorldPoints(objects.wallLeft.shape:getPoints()))
	love.graphics.polygon("fill", objects.wallRight.body:getWorldPoints(objects.wallRight.shape:getPoints()))
	
	--Desenhando a pontuação
	love.graphics.setColor(180, 180, 180)
	love.graphics.print("Score: " .. score, 330, 280, 0, 2, 2)
	love.graphics.print("Record: " .. record, 330, 310, 0, 2, 2)
	
end

function beginContact(a, b)
	--Contando os contatos entre a Bola e a Plataforma
	if	a:getUserData() == "Floor" and b:getUserData()=="Ball" then
		score = score + 1
	end
end