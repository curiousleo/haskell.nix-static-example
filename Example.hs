{-# LANGUAGE DataKinds #-}
{-# LANGUAGE GADTs #-}

module Main where

import ExampleService
import Network.GRPC.HighLevel.Generated (defaultServiceOptions)
import Network.GRPC.HighLevel.Server
import Network.GRPC.LowLevel

doHandler :: ServerRequest 'Normal DoRequest DoResponse -> IO (ServerResponse 'Normal DoResponse)
doHandler (ServerNormalRequest _meta (DoRequest {})) =
  pure (ServerNormalResponse (DoResponse {}) mempty StatusOk (StatusDetails mempty))

main :: IO ()
main = exampleServiceServer (ExampleService { exampleServiceDo = doHandler }) defaultServiceOptions
