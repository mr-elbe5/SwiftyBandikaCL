//
//  main.swift
//  SwiftyBandikaCL
//
//  Created by Michael Rönnau on 28.03.21.
//

import Foundation

Paths.initPaths()
Localizer.initialize(languages: ["en","de"])
Application.instance.initializeData()
ActionQueue.instance.addRegularAction(CleanupAction())
ActionQueue.instance.start()
HttpServer.instance.start()
print("please type 'quit' to stop the server")
var result = ""
repeat{
    result = readLine() ?? ""
}
while result != "quit"
print("stopping server...")
HttpServer.instance.stop()
ActionQueue.instance.checkActions()
ActionQueue.instance.stop()
print("server stopped")
