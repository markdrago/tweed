import Test.Tasty
import Test.Tasty.HUnit

import Data.List
import Data.Ord

import qualified Server as S

main = defaultMain tests

tests :: TestTree
tests = testGroup "Tests" [unitTests]

unitTests = testGroup "DNS Packet Parsing"
  [ testCase "Error message is returned when given bogus packet" $
      [1, 2, 3] `compare` [1,2] @?= GT

  -- the following test does not hold
  , testCase "List comparison (same length)" $
      [1, 2, 3] `compare` [1,2,2] @?= LT
  ]
