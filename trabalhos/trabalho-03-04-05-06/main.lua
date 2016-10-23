function love.load()
	
	love.physics.setMeter(64)
	world = love.physics.newWorld(0, 0, true)
	world:setCallbacks(beginContact)
	
	-- Trabalho 06: Registro
	saida = { score = 0,
	-- Trabalho 04 (Quando o trabalho 4 foi feito, 'score' não pertencia a variável de registro 'saida')
	-- Nome: score
	-- Propriedade: Endereço
	-- Binding Time: Compilação
	-- Explicação: Por ser uma variável global, seu endereço é conhecido em tempo de compilação
	record = 0 }

	-- Trabalho 06: Tupla
	msgGameOver = {"Game Over =(", 220, 250, 0, 4, 4}
	msgRecord = {"Record: ", 340, 310, 0, 2, 2}
	msgToReset = {"Press R to Reset!", 290, 340, 0, 2, 2}
	
	temp = 0

	aux = 0

	contball = 0

	gameover = false


	-- Trabalho 06: Array
	objects = {}
	-- Trabalho 05: coleção dinâmica de objetos
	-- Coleção dinamica de objetos
	-- Escopo: Global
	-- Tempo de vida: Todo o tempo de execução
	-- Alocação: A alocação é feita dinamicamente e não tem tamanho fixo, ou seja, é ilimitada
	-- Desalocação: Ao final da execução

	-- Trabalho 06: Dicionário
	bolas = {}
	
	objects.wallLeft = {}
	objects.wallLeft.body = love.physics.newBody(world, 5, love.graphics.getHeight()/2)
	objects.wallLeft.shape = love.physics.newRectangleShape(10, love.graphics.getHeight())
	objects.wallLeft.fixture = love.physics.newFixture(objects.wallLeft.body, objects.wallLeft.shape)
	objects.wallLeft.fixture:setFriction(0)
	
	objects.wallRight = {}
	objects.wallRight.body = love.physics.newBody(world, love.graphics.getWidth()-5, love.graphics.getHeight()/2)
	objects.wallRight.shape = love.physics.newRectangleShape(10, love.graphics.getHeight())
	objects.wallRight.fixture = love.physics.newFixture(objects.wallRight.body, objects.wallRight.shape)
	objects.wallRight.fixture:setFriction(0)
	
	objects.roof = {}
	objects.roof.body = love.physics.newBody(world, love.graphics.getWidth()/2, 5)
	objects.roof.shape = love.physics.newRectangleShape(love.graphics.getWidth(), 10)
	objects.roof.fixture = love.physics.newFixture(objects.roof.body, objects.roof.shape)
	objects.roof.fixture:setFriction(0)

	objects.polygon = {}
	objects.polygon.body = love.physics.newBody(world, love.graphics.getWidth()/2, love.graphics.getHeight()-7.5)
	objects.polygon.shape = love.physics.newPolygonShape(-75, -4, 1, -15, 75, -4, -75, 7.5, 75, 7.5)
	objects.polygon.fixture = love.physics.newFixture(objects.polygon.body, objects.polygon.shape)
	objects.polygon.fixture:setFriction(0)
	objects.polygon.fixture:setUserData("Floor")
	
end

function love.update(dt)
	-- Trabalho 04
	-- Nome: dt
	-- Propriedade: Endereço
	-- Binding time: Execução
	-- Explicação: Por 'dt' ser uma variável local e ter escopo limitado a
	-- 	       função 'love.update', seu endereço é definido em tempo de execução

	world:update(dt)
	
	temp = temp + dt
	-- Trabalho 04
	-- Nome: +
	-- Propriedade: Semântica da linguagem
	-- Binding time: Compilação
	-- Explicaçao: A instrução de adição é definida em tempo de
	--             compilação, dependendo dos tipos dos operandos

	if temp > aux and not gameover then
		aux = aux + 6
		j = 0
		while bolas[j] ~= nil do
			j = j + 1
		end

		-- Trabalho 05: criar novos objetos periodicamente
		bolas[j] = {}
		-- Escopo: Global
		-- Tempo de vida: Desde a sua criação até a execução da linha 124
		-- Alocação: A alocação é feita dinamicamente. Neste caso, alocamos um array dentro de outro array
		-- Desalocação: Linha 124

		bolas[j].body = love.physics.newBody(world, love.graphics.getWidth()/2, 20, "dynamic")
		bolas[j].shape = love.physics.newCircleShape(10)
		bolas[j].fixture = love.physics.newFixture(bolas[j].body, bolas[j].shape)
		bolas[j].body:setLinearVelocity(0, 850 + contball*50)
		bolas[j].fixture:setRestitution(1.005)
		bolas[j].fixture:setFriction(0)
		bolas[j].fixture:setUserData("Ball$contball")
		contball = contball + 1
	end
	-- Trabalho 04
	-- Nome: then
	-- Propriedade: Semântica
	-- Binding time: Design
	-- Explicação: Foi definido, durante a implementação da linguagem, 
	-- 	       que a palavra reservada 'then' definiria o fim da sentença lógica do bloco de decisão

	if love.keyboard.isDown("right") and not gameover then
		objects.polygon.body:setPosition(objects.polygon.body:getX() + 18, love.graphics.getHeight()-7.5)
	elseif love.keyboard.isDown("left") and not gameover then
		objects.polygon.body:setPosition(objects.polygon.body:getX() - 18, love.graphics.getHeight()-7.5)
	end
	
	if objects.polygon.body:getX() < 86 then
		objects.polygon.body:setX(86)
	elseif objects.polygon.body:getX() > love.graphics.getWidth()-86 then
		objects.polygon.body:setX(love.graphics.getWidth()-86)
	end

	-- Trabalho 05: remover objetos
	if not gameover then
		for i = 0, contball do
			if bolas[i] ~= nil then
				if bolas[i].body:getY() > love.graphics.getHeight() then
					contball = contball - 1
					bolas[i] = nil
				end
			end
		end
	end
	-- Trabalho 04
	-- Nome: end
	-- Propriedade: Semântica
	-- Binding time: Design
	-- Explicação: Foi definido, durante a implementação da linguagem, 
	-- 	       que a palavra reservada 'end' definiria o fim do bloco de decisão

	if contball == 0 and not gameover then
		gameover = true
		if saida.score > saida.record then
			saida.record = saida.score
		end
		saida.score = 0
		objects.polygon.body:setPosition(love.graphics.getWidth()/2, love.graphics.getHeight()-7.5)
	end

	if love.keyboard.isDown("r") and gameover then
		gameover = false
		contball = 0
		temp = 0
		aux = 0
	end

end

function love.draw()

	love.graphics.setColor(215, 60, 130)
	love.graphics.polygon("fill", objects.polygon.body:getWorldPoints(objects.polygon.shape:getPoints()))
	
	for i = 0, contball do
		if bolas[i] ~= nil then
			love.graphics.setColor(255, 255, 255)
			love.graphics.circle("fill", bolas[i].body:getX(), bolas[i].body:getY(), bolas[i].shape:getRadius())
		end
	end

	love.graphics.setColor(102, 204, 0)
	love.graphics.polygon("fill", objects.roof.body:getWorldPoints(objects.roof.shape:getPoints()))
	love.graphics.polygon("fill", objects.wallLeft.body:getWorldPoints(objects.wallLeft.shape:getPoints()))
	love.graphics.polygon("fill", objects.wallRight.body:getWorldPoints(objects.wallRight.shape:getPoints()))

	if not gameover then
		love.graphics.setColor(180, 180, 180)
		love.graphics.print("Score: " .. saida.score, 340, 280, 0, 2, 2)
		love.graphics.print("Record: " .. saida.record, 340, 310, 0, 2, 2)
	end

	if gameover then
		love.graphics.setColor(180, 180, 180)
		love.graphics.print(msgGameOver[1], msgGameOver[2], msgGameOver[3], msgGameOver[4], msgGameOver[5])
		love.graphics.print(msgRecord[1] .. saida.record, msgRecord[2], msgRecord[3], msgRecord[4], msgRecord[5], msgRecord[6])
		love.graphics.print(msgToReset[1], msgToReset[2], msgToReset[3], msgToReset[4], msgToReset[5])
	end
	
end

-- Trabalho 05: Objetos devem interagir entre si
function beginContact(a, b)
-- Trabalho 04
-- Nome: b
-- Propriedade: Valor
-- Binding time: Execução
-- Explicação: A variável 'b' só receberá algum valor quando a função
-- 	       for executada, ou seja, em tempo de execução

	ator1 = a:getUserData()
	ator2 = b:getUserData()

	if ator1 ~= nil and ator2 ~= nil then
		if	(a:getUserData() == "Floor" and (string.find(ator2, "Ball") ~= nil))  or ((string.find(ator1, "Ball") ~= nil) and b:getUserData()=="Floor") then
			saida.score = saida.score + 1
		end
	end
end