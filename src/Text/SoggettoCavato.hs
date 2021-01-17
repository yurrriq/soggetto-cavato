-- ------------------------------------------------------- [ SoggettoCavato.hs ]
-- |
-- Module      : Text.SoggettoCavato
-- Copyright   : (c) 2017, 2020, Eric Bailey
-- License     : BSD-style (see LICENSE)
--
-- Maintainer  : eric@ericb.me
-- Stability   : experimental
-- Portability : portable
--
-- Carve words from music.
------------------------------------------------------------------------ [ EOH ]
module Text.SoggettoCavato
  (
    fromString
  ) where

import           Data.Char  (toLower)
import           Data.Maybe (mapMaybe)
import           Euterpea   (AbsPitch, Pitch, pitch)

{- | Carve a list of 'Pitch'es from a 'String'.

>>> fromString "Soggetto Cavato"
[(F,4),(D,4),(F,4),(C,4),(C,4),(F,4)]
-}
fromString :: String -> [Pitch]
fromString = mapMaybe (toPitch . toLower)

-- ------------------------------------------------------ [ Internal Functions ]

toPitch :: Char -> Maybe Pitch
toPitch = pitch <.> toAbsPitch

-- | Convert a vowel to 'Just' its corresponding 'AbsPitch'.
toAbsPitch :: Char -> Maybe AbsPitch
toAbsPitch 'a' = Just 60
toAbsPitch 'e' = Just 62
toAbsPitch 'i' = Just 64
toAbsPitch 'o' = Just 65
toAbsPitch 'u' = Just 67
toAbsPitch  _  = Nothing

-- ------------------------------------------------------ [ Agda.Utils.Functor ]

infixr 9 <.>

-- | Composition: pure function after functorial (monadic) function.
(<.>) :: Functor m => (b -> c) -> (a -> m b) -> a -> m c
(f <.> g) a = f <$> g a

-- --------------------------------------------------------------------- [ EOF ]
