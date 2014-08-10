import qualified Data.ByteString.UTF8 as UTF8
import qualified Data.ByteString as B
import qualified Data.ByteString.Lazy as BL
import Network.Socket hiding (send, sendTo, recv, recvFrom)
import Network.Socket.ByteString
import Network.DNS as DNS

type HandlerFunc = B.ByteString -> IO ()

main :: IO ()
main = serveLog "1234" logHandler

serveLog :: String
         -> HandlerFunc
         -> IO ()

serveLog port handlerFunc = withSocketsDo $
    do
      addrinfos <- getAddrInfo
                   (Just (defaultHints {addrFlags = [AI_PASSIVE]}))
                   Nothing (Just port)
      let serveraddr = head addrinfos
                       
      sock <- socket (addrFamily serveraddr) Datagram defaultProtocol

      bind sock (addrAddress serveraddr)

      procMessages sock
    where procMessages sock =
              do
                (msg, addr) <- recvFrom sock 1024
                handlerFunc msg
                procMessages sock

logHandler :: HandlerFunc
logHandler msg =
    case domainFromRequest msg of
      Left msg -> putStrLn msg
      Right domain -> putStrLn $ UTF8.toString domain

domainFromRequest :: B.ByteString -> Either String Domain
domainFromRequest msg = 
    case DNS.decode (BL.fromStrict msg) of
      Left msg -> Left msg
      Right packet -> Right (qname (head (question packet)))
