module Main where
import Network.MateLight.Simple

import Data.Maybe
import qualified Network.Socket as Sock

import TypeDefs
import Utilities
import LevelGen
import Player
import Area

initGameState :: GameState
initGameState = (genVisAreas 0, 0, ((0, 2), 0))

drawCanvas :: GameState -> Canvas
-- PURPOSE
-- draws the canvas
drawCanvas (areas, time, player) = drawPlayerToCanvas player $ drawNumber (reverse (digs time)) 0 $ drawAreasCanvas areas time

eventHandler :: GameState -> [Event String] -> GameState
eventHandler state@(areas, time, player) events = (areas, time, playerEvents events state)

increaseTime :: GameState -> GameState
-- PURPOSE
-- increases the current time of the gamestate by 1
increaseTime (a,t,p) = (a, t + 1, p)

toFrame :: [Event String] -> GameState -> (ListFrame, GameState)
toFrame events (a, t, p) = (ListFrame (drawCanvas gameState), gameState)
  where
    time      = t+1
    areas     = genVisAreas time
    player    = playerTick (areas, time, p)
    gameState | not (isPlayerInAreas (areas, time, p)) = eventHandler (areas, time, player) events
              | otherwise                              = initGameState
main :: IO ()
--main = Sock.withSocketsDo $ runMate (Config (fromJust $ parseAddress "127.0.0.1") 1337 dim (Just 33000) False []) toFrame (level, 0)
main = Sock.withSocketsDo $ runMate (Config (fromJust $ parseAddress "134.28.70.172") 1337 dim (Just 33000) True []) toFrame initGameState
