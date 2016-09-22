function love.load()
	
	--Declarando o mundo do jogo (sem gravidade)
	love.physics.setMeter(64)
	world = love.physics.newWorld(0, 0, true)
	world:setCallbacks(beginContact)
	
	score = 0 --Pontuação atual
	
	record = 0 --Maior pontuação alcançada
	
	temp = 0 --Contador de tempo para surgimento de bolas

	aux = 0 --Auxiliar de intervalo entre tempo de surgimento de bolas

	i = 0 --Auxiliar para iterar no array bolas

	contball = 0 --Contador de bolas em movimento

	gameover = false

	objects = {} --Coleção dinamica de objetos (Trabalho 05: adicionar ao jogo uma coleção dinâmica de objetos)
	--Escopo: Global
	--Tempo de vida: Todo o tempo de execução
	--Alocação: A alocação é feita dinamicamente e não tem tamanho fixo, ou seja, é ilimitada
	--Desalocação: Ao final da execução

	bolas = {} --Coleção dinamica de objetos
	
	--Criando a parede da esquerda
	objects.wallLeft = {}
	objects.wallLeft.body = love.physics.newBody(world, 5, love.graphics.getHeight()/2)
	objects.wallLeft.shape = love.physics.newRectangleShape(10, love.graphics.getHeight())
	objects.wallLeft.fixture = love.physics.newFixture(objects.wallLeft.body, objects.wallLeft.shape)
	objects.wallLeft.fixture:setFriction(0)
	
	--Criando a parede da direita
	objects.wallRight = {}
	objects.wallRight.body = love.physics.newBody(world, love.graphics.getWidth()-5, love.graphics.getHeight()/2)
	objects.wallRight.shape = love.physics.newRectangleShape(10, love.graphics.getHeight())
	objects.wallRight.fixture = love.physics.newFixture(objects.wallRight.body, objects.wallRight.shape)
	objects.wallRight.fixture:setFriction(0)
	
	--Criando o teto
	objects.roof = {}
	objects.roof.body = love.physics.newBody(world, love.graphics.getWidth()/2, 5)
	objects.roof.shape = love.physics.newRectangleShape(love.graphics.getWidth(), 10)
	objects.roof.fixture = love.physics.newFixture(objects.roof.body, objects.roof.shape)
	objects.roof.fixture:setFriction(0)

	--Criando a plataforma no chão
	objects.polygon = {}
	objects.polygon.body = love.physics.newBody(world, love.graphics.getWidth()/2, love.graphics.getHeight()-7.5)
	objects.polygon.shape = love.physics.newPolygonShape(-75, -4, 1, -15, 75, -4, -75, 7.5, 75, 7.5)
	objects.polygon.fixture = love.physics.newFixture(objects.polygon.body, objects.polygon.shape)
	objects.polygon.fixture:setFriction(0)
	objects.polygon.fixture:setUserData("Floor")
	
end

function love.update(dt)
	-- Nome: Variável 'dt'
	-- Propriedade: Endereço
	-- Binding time: Execução
	-- Explicação: Por 'dt' ser uma variável local e ter escopo limitado a
	-- função 'love.update', seu endereço é definido em tempo de execução

	world:update(dt)
	
	temp = temp + dt
	-- Nome: Operador '+'
	-- Propriedade: Semântica da linguagem
	-- Binding time: Compilação
	-- Explicaçao: A instrução de adição é definida em tempo de
	-- compilação, dependendo dos tipos dos operandos
	-- (double, float, int)

	if temp > aux and not gameover then
		aux = aux + 6
		i = i + 1

		--Criando as bolas (Trabalho 05: criar novos objetos periodicamente)
		bolas[i] = {}
		--Escopo: Global
		--Tempo de vida: Desde a sua criação até o final da execução, ou até que seja criado outro objeto por cima (Irá acontece quando o jogo for resetado)
		--Alocação: A alocação é feita dinamicamente. Neste caso, alocamos um array dentro de outro array
		--Desalocação: Ao final da execução

		bolas[i].body = love.physics.newBody(world, love.graphics.getWidth()/2, 20, "dynamic")
		bolas[i].shape = love.physics.newCircleShape(10)
		bolas[i].fixture = love.physics.newFixture(bolas[i].body, bolas[i].shape)
		bolas[i].inGame = true
		bolas[i].body:setLinearVelocity(0, 850 + contball*50)
		bolas[i].fixture:setRestitution(1.005)
		bolas[i].fixture:setFriction(0)
		bolas[i].fixture:setUserData("Ball$contball")
		contball = contball + 1
	end
	-- Nome: Palavra reservada 'then'
	-- Propriedade: Definição de estrutura de decisão
	-- Binding time: Design
	-- Explicação: Foi definido, durante a implementação da linguagem, 
	-- que a palavra reservada 'else' definiria o fim da sentença lógica do bloco de decisão

	--Movendo a plataforma
	if love.keyboard.isDown("right") and not gameover then
		objects.polygon.body:setPosition(objects.polygon.body:getX() + 18, love.graphics.getHeight()-7.5)
	elseif love.keyboard.isDown("left") and not gameover then
		objects.polygon.body:setPosition(objects.polygon.body:getX() - 18, love.graphics.getHeight()-7.5)
	end
	
	--Limitando a plataforma até as paredes
	if objects.polygon.body:getX() < 86 then
		objects.polygon.body:setX(86)
	elseif objects.polygon.body:getX() > love.graphics.getWidth()-86 then
		objects.polygon.body:setX(love.graphics.getWidth()-86)
	end

	--Remover bolas (Trabalho 05: remover objetos)
	if not gameover then
		for j = 1, i do
			if (bolas[j].body:getY() > love.graphics.getHeight()) and bolas[j].inGame then
				contball = contball - 1
				bolas[j].inGame = false
			end
		end
	end
	-- Nome: Palavra reservada 'end'
	-- Propriedade: Definição de estrutura de decisão
	-- Binding time: Design
	-- Explicação: Foi definido, durante a implementação da linguagem, 
	-- que a palavra reservada 'end' definiria o fim do bloco de decisão

	if contball == 0 and not gameover then
		gameover = true
		if score > record then
			record = score
		end
		score = 0
		objects.polygon.body:setPosition(love.graphics.getWidth()/2, love.graphics.getHeight()-7.5)
		-- Nome: Operador '-'
		-- Propriedade: Semântica da linguagem
		-- Binding time: Compilação
		-- Explicaçao: A instrução de subtração é definida em tempo de
		-- compilação, dependendo dos tipos dos operandos
		-- (double, float, int)
	end

	--Resetando o jogo
	if love.keyboard.isDown("r") and gameover then
		gameover = false
		i = 0
		contball = 0
		temp = 0
		aux = 0
	end

end

function love.draw()

	--Desenhando a plataforma
	love.graphics.setColor(215, 60, 130)
	love.graphics.polygon("fill", objects.polygon.body:getWorldPoints(objects.polygon.shape:getPoints()))
	
	--Desenhando as Bolas
	for j = 1, i do
		if bolas[j].inGame then
			love.graphics.setColor(255, 255, 255)
			love.graphics.circle("fill", bolas[j].body:getX(), bolas[j].body:getY(), bolas[j].shape:getRadius())
		end
	end

	--Desenhando o teto e as paredes
	love.graphics.setColor(102, 204, 0)
	love.graphics.polygon("fill", objects.roof.body:getWorldPoints(objects.roof.shape:getPoints()))
	love.graphics.polygon("fill", objects.wallLeft.body:getWorldPoints(objects.wallLeft.shape:getPoints()))
	love.graphics.polygon("fill", objects.wallRight.body:getWorldPoints(objects.wallRight.shape:getPoints()))
	
	--Desenhando a pontuação
	if not gameover then
		love.graphics.setColor(180, 180, 180)
		love.graphics.print("Score: " .. score, 340, 280, 0, 2, 2)
		love.graphics.print("Record: " .. record, 340, 310, 0, 2, 2)
	end

	if gameover then
		love.graphics.setColor(180, 180, 180)
		love.graphics.print("Game Over =(", 220, 250, 0, 4, 4)
		love.graphics.print("Record: " .. record, 340, 310, 0, 2, 2)
		love.graphics.print("Press R to Reset!", 290, 340, 0, 2, 2)
	end
	
end


function beginContact(a, b) --Colisão (Trabalho 05: Objetos devem interagir entre si)
-- Nome: Variável 'b'
-- Propriedade: Valor
-- Binding time: Execução
-- Explicação: A variável 'b' só receberá algum valor quando a função
-- for executada, ou seja, em tempo de execução

	ator1 = a:getUserData()
	ator2 = b:getUserData()

	--Contando os contatos entre a Bola e a Plataforma
	if ator1 ~= nil and ator2 ~= nil then
		if	(a:getUserData() == "Floor" and (string.find(ator2, "Ball") ~= nil))  or ((string.find(ator1, "Ball") ~= nil) and b:getUserData()=="Floor") then
			score = score + 1
		end
	end
end
