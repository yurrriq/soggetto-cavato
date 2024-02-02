{-# LANGUAGE TupleSections #-}

-- |
-- Module      : Text.SoggettoCavato
-- Copyright   : (c) 2017, 2020, 2024, Eric Bailey
-- License     : BSD-style (see LICENSE)
--
-- Maintainer  : eric@ericb.me
-- Stability   : experimental
-- Portability : portable
--
-- Carve words from music.
module Text.SoggettoCavato
  ( fromString,
  )
where

import Data.Char (toLower)
import Data.Maybe (mapMaybe)

type Pitch = (PitchClass, Octave)

data PitchClass
  = C
  | D
  | E
  | F
  | G
  | A
  | B
  deriving (Bounded, Enum, Eq, Ord, Read, Show)

type Octave = Int

-- | Carve a list of 'Pitch'es from a 'String'.
--
-- >>> fromString "Soggetto Cavato"
-- [(F,4),(D,4),(F,4),(C,4),(C,4),(F,4)]
fromString :: String -> [Pitch]
fromString = mapMaybe (toPitch . toLower)

toPitch :: Char -> Maybe Pitch
toPitch = (,4) <.> toPitchClass

-- | Convert a vowel to 'Just' its corresponding 'PitchClass'.
toPitchClass :: Char -> Maybe PitchClass
toPitchClass 'a' = Just F -- Fa
toPitchClass 'e' = Just D -- Re
toPitchClass 'i' = Just E -- Mi
toPitchClass 'o' = Just G -- Sol
toPitchClass 'u' = Just C -- Ut
toPitchClass 'y' = Just C -- Ut
toPitchClass _ = Nothing

infixr 9 <.>

-- | Composition: pure function after functorial (monadic) function.
-- Borrowed from Agda.Utils.Functor
(<.>) :: (Functor m) => (b -> c) -> (a -> m b) -> a -> m c
(f <.> g) a = f <$> g a
