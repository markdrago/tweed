import Server (serveLog, logHandler)

main :: IO ()
main = serveLog "1234" logHandler
