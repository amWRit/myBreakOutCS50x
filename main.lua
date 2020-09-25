require 'src/Dependencies'

function love.load()
	love.graphics.setDefaultFilter('nearest', 'nearest')
	math.randomseed(os.time())
	love.window.setTitle("Aau Futau")

	gFonts = {
		['small'] = love.graphics.newFont('fonts/font.ttf', 8),
		['medium'] = love.graphics.newFont('fonts/font.ttf', 16),
		['large'] = love.graphics.newFont('fonts/font.ttf', 32)
	}

	gTextures = {
		['background'] = love.graphics.newImage('graphics/background.png'),
		['main'] = love.graphics.newImage('graphics/breakout.png'),
		['arrows'] = love.graphics.newImage('graphics/arrows.png'),
		['hearts'] = love.graphics.newImage('graphics/hearts.png'),
		['particle'] = love.graphics.newImage('graphics/particle.png')
	}

	gFrames = {
		['paddles'] = GenerateQuadsPaddles(gTextures['main']),
		['balls'] = GenerateQuadsBalls(gTextures['main']),
		['bricks'] = GenerateQuadsBricks(gTextures['main'])
	}

	push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
		vsync = true,
		resizable = true,
		fulscreen = false
	})

	gSounds = {
		['paddle-hit'] = love.audio.newSource('sounds/paddle_hit.wav', 'static'),
		['score'] = love.audio.newSource('sounds/score.wav', 'static'),
		['wall-hit'] = love.audio.newSource('sounds/wall_hit.wav', 'static'),
		['confirm'] = love.audio.newSource('sounds/confirm.wav', 'static'),
		['select'] = love.audio.newSource('sounds/select.wav', 'static'),
		['no-select'] = love.audio.newSource('sounds/no-select.wav', 'static'),
		['brick-hit-1'] = love.audio.newSource('sounds/brick-hit-1.wav', 'static'),
		['brick-hit-2'] = love.audio.newSource('sounds/brick-hit-2.wav', 'static'),
		['hurt'] = love.audio.newSource('sounds/hurt.wav', 'static'),
		['victory'] = love.audio.newSource('sounds/victory.wav', 'static'),
		['recover'] = love.audio.newSource('sounds/recover.wav', 'static'),
		['high-score'] = love.audio.newSource('sounds/high_score.wav', 'static'),
		['pause'] = love.audio.newSource('sounds/pause.wav', 'static'),

		['music'] = love.audio.newSource('sounds/music.wav', 'static')
	}

    gStateMachine = StateMachine {
        ['start'] = function() return StartState() end,
        ['play'] = function() return PlayState() end
    }
    gStateMachine:change('start')
	
	love.keyboard.keysPressed = {}
end

function love.resize(w,h)
	push:resize(w,h)
end

function love.update(dt)
	gStateMachine:update(dt)

	love.keyboard.keysPressed = {}
end

function love.keypressed(key)
	love.keyboard.keysPressed[key] = true
end

function love.keyboard.wasPressed(key)
	return love.keyboard.keysPressed[key]
end

function love.draw()
	push:start()

	local backgroundWidth = gTextures['background']:getWidth()
	local backgroundheight = gTextures['background']:getHeight()	

	love.graphics.draw(gTextures['background'], 0, 0, 
		0, VIRTUAL_WIDTH/ (backgroundWidth-1), VIRTUAL_HEIGHT/(backgroundheight-1) -- rotation, scaleX, scaleY
		)

	gStateMachine:render()
	push:finish()
end