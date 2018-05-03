-----------------------------------------------------------------------------------------
--
-- main.lua
--
-- Created by: Amin Zeina
-- Created on: Apr 2018
--
-- Explosion
-----------------------------------------------------------------------------------------

local physics = require( "physics" )

physics.start()
physics.setGravity( 0, 25 )
physics.setDrawMode( "hybrid" )

local playerBullets = {} -- table for bullets
local score = 0

local theGround = display.newImage( "./assets/sprites/land.png" )
theGround.x = display.contentCenterX - 600
theGround.y = display.contentHeight
theGround.id = "the ground"
physics.addBody( theGround, 'static', {
    friction = 0.5, 
    bounce = 0.3 
    } )

local theGround2 = display.newImage( "./assets/sprites/land.png" )
theGround2.x = 1450
theGround2.y = display.contentHeight
theGround2.id = "the ground"
physics.addBody( theGround2, 'static', {
    friction = 0.5, 
    bounce = 0.3 
    } )

local leftWall = display.newRect( 0, display.contentHeight / 2, 1, display.contentHeight )
physics.addBody( leftWall, "static", { 
    friction = 0.5, 
    bounce = 0.3 
    } )
leftWall.id = "Left Wall"

local theCharacter = display.newImage( "./assets/sprites/ninjaBoy.png" )
theCharacter.x = display.contentCenterX - 800
theCharacter.y = display.contentCenterY
theCharacter.id = "the character"
physics.addBody( theCharacter, "dynamic", { 
    density = 3.0, 
    friction = 0.5, 
    bounce = 0.3 
    } )
theCharacter.isFixedRotation = true

local ninjaGirl = display.newImage( "./assets/sprites/ninjaGirl.png" )
ninjaGirl.x = display.contentCenterX + 500
ninjaGirl.y = display.contentCenterY
ninjaGirl.id = "enemy character"
physics.addBody( ninjaGirl, "dynamic", { 
    density = 3.0, 
    friction = 0.5, 
    bounce = 0.3 
    } )
ninjaGirl.isFixedRotation = true
ninjaGirl.xScale = -1

local dPad = display.newImage( "./assets/sprites/d-pad.png" )
dPad.x = 150
dPad.y = display.contentHeight - 150
dPad.id = "d-pad"
dPad.alpha = 0.50

local upArrow = display.newImage( "./assets/sprites/upArrow.png" )
upArrow.x = 150
upArrow.y = display.contentHeight - 260
upArrow.id = "up arrow"

local downArrow = display.newImage( "./assets/sprites/downArrow.png" )
downArrow.x = 150
downArrow.y = display.contentHeight - 40
downArrow.id = "down arrow"

local rightArrow = display.newImage( "./assets/sprites/rightArrow.png" )
rightArrow.x = 260
rightArrow.y = display.contentHeight - 150
rightArrow.id = "right arrow"

local leftArrow = display.newImage( "./assets/sprites/leftArrow.png" )
leftArrow.x = 40
leftArrow.y = display.contentHeight - 150
leftArrow.id = "left arrow"

local jumpButton = display.newImage( "./assets/sprites/jumpButton.png" )
jumpButton.x = display.contentWidth - 80
jumpButton.y = display.contentHeight - 100
jumpButton.id = "jump button"
jumpButton.alpha = 0.5

local shootButton = display.newImage( "./assets/sprites/jumpButton.png" )
shootButton.x = display.contentWidth - 250
shootButton.y = display.contentHeight - 100
shootButton.id = "shootButton"
shootButton.alpha = 0.5

local function characterCollision( self, event )
    -- print what the chararcter collided with
    if ( event.phase == "began" ) then
        print( self.id .. ": collision began with " .. event.other.id )
 
    elseif ( event.phase == "ended" ) then
        print( self.id .. ": collision ended with " .. event.other.id )
    end
end

local function checkPlayerBulletsOutOfBounds()
	-- check if bullets are off the screen and rmoves them 
	local bulletCounter

    if #playerBullets > 0 then
        for bulletCounter = #playerBullets, 1 ,-1 do
            if playerBullets[bulletCounter].x > display.contentWidth + 1000 then
                playerBullets[bulletCounter]:removeSelf()
                playerBullets[bulletCounter] = nil
                table.remove(playerBullets, bulletCounter)
                print("remove bullet")
            end
        end
    end
end

local function checkCharacterPosition( event )
    -- respawn character if it falls off the map
    if theCharacter.y > display.contentHeight + 500 then
        theCharacter.x = display.contentCenterX - 200
        theCharacter.y = display.contentCenterY
    end
end

local function onCollision( event )
 
    if ( event.phase == "began" ) then
 
        local obj1 = event.object1
        local obj2 = event.object2

        if ( ( obj1.id == "enemy character" and obj2.id == "bullet" ) or
             ( obj1.id == "bullet" and obj2.id == "enemy character" ) ) then
            -- Table of emitter parameters
            local emitterParams = {
                startColorAlpha = 1,
                startParticleSizeVariance = 500,
                startColorGreen = 0,
                yCoordFlipped = -1,
                blendFuncSource = 770,
                rotatePerSecondVariance = 153.95,
                particleLifespan = 0.8,
                tangentialAcceleration = -1440.74,
                finishColorBlue = 0.5,
                finishColorGreen = 0,
                blendFuncDestination = 1,
                startParticleSize = 400.95,
                startColorRed = 0.8373094,
                textureFileName = "./assets/sprites/fire.png",
                startColorVarianceAlpha = 1,
                maxParticles = 256,
                finishParticleSize = 600,
                duration = 0.25,
                finishColorRed = 1,
                maxRadiusVariance = 72.63,
                finishParticleSizeVariance = 250,
                gravityy = 671.05,
                speedVariance = 90.79,
                tangentialAccelVariance = -420.11,
                angleVariance = -142.62,
                angle = -244.11
            }
            -- show explosion
            local emitter = display.newEmitter( emitterParams )
            emitter.x = obj1.x
            emitter.y = obj1.y

 			-- Remove bullet
            for bulletCounter = #playerBullets, 1, -1 do
                if ( playerBullets[bulletCounter] == obj1 or playerBullets[bulletCounter] == obj2 ) then
                    playerBullets[bulletCounter]:removeSelf()
                    playerBullets[bulletCounter] = nil
                    table.remove( playerBullets, bulletCounter )
                    break
                end
            end
            -- Remove character
            ninjaGirl:removeSelf()
           	ninjaGirl = nil	
            -- Increase score
            score = score + 1 

            -- Play Explosion sound 
            local expolsionSound = audio.loadSound( "./assets/audio/bombExplosion.wav" )
            audio.play( expolsionSound )

        end
    end
end

function upArrow:touch( event )
    if ( event.phase == "ended" ) then
        -- moves character up
        transition.moveBy( theCharacter, { 
            x = 0, -- move 0 pixels horizontally
            y = -50, -- move 50 pixels up
            time = 100 -- move in 100 milliseconds
            } )
    end

    return true
end

function downArrow:touch( event )
    if ( event.phase == "ended" ) then
        -- moves character down
        transition.moveBy( theCharacter, { 
            x = 0, -- move 0 pixels horizontally
            y = 50, -- move 50 pixels down
            time = 100 -- move in 100 milliseconds
            } )
    end

    return true
end

function rightArrow:touch( event )
    if ( event.phase == "ended" ) then
        -- Turns Character
        theCharacter.xScale = 1
        -- moves character right
        transition.moveBy( theCharacter, { 
            x = 50, -- move 50 pixels right
            y = 0, -- move 0 pixels vertically
            time = 100 -- move in 100 milliseconds
            } )
    end

    return true
end

function leftArrow:touch( event )
    if ( event.phase == "ended" ) then
        -- Turns Character
        theCharacter.xScale = -1
        -- moves character left
        transition.moveBy( theCharacter, { 
            x = - 50, -- move 50 pixels left
            y = 0, -- move 0 pixels vertically
            time = 100 -- move in 100 milliseconds
            } )
    end

    return true
end

function jumpButton:touch( event )
    if ( event.phase == "ended" ) then
        -- makes character jump
        theCharacter:setLinearVelocity( 0, -750 )
    end

    return true
end

function shootButton:touch( event )
    if ( event.phase == "began" ) then
        -- puts bullet on screen at character postion
        local aSingleBullet = display.newImage( "./assets/sprites/kunai.png" )
        aSingleBullet.x = theCharacter.x
        aSingleBullet.y = theCharacter.y
        physics.addBody( aSingleBullet, 'dynamic' )
        -- Makes sprite a "bullet" type object
        aSingleBullet.isBullet = true
        aSingleBullet.gravityScale = 0
        aSingleBullet.id = "bullet"
        aSingleBullet:setLinearVelocity( 1500, 0 )
        aSingleBullet.isFixedRotation = true

        table.insert(playerBullets,aSingleBullet)
        print("# of bullet: " .. tostring(#playerBullets))
    end

    return true
end


upArrow:addEventListener( "touch", upArrow )
downArrow:addEventListener( "touch", downArrow )
rightArrow:addEventListener( "touch", rightArrow )
leftArrow:addEventListener( "touch", leftArrow )
jumpButton:addEventListener( "touch", jumpButton )
shootButton:addEventListener( "touch", shootButton )

theCharacter.collision = characterCollision
theCharacter:addEventListener( 'collision')

Runtime:addEventListener( "enterFrame", checkCharacterPosition )
Runtime:addEventListener( "enterFrame", checkPlayerBulletsOutOfBounds )
Runtime:addEventListener( "collision", onCollision)