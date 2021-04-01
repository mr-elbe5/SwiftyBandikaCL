/*
 SwiftyBandika CMS - A Swift based Content Management System with JSON Database
 Copyright (C) 2021 Michael Roennau

 This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 3 of the License, or (at your option) any later version.
 This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
 You should have received a copy of the GNU General Public License along with this program; if not, see <http://www.gnu.org/licenses/>.
*/
import Foundation

struct Application{
    
    static var instance = Application()

    var language : String{
        Statics.instance.defaultLocale.languageCode ?? "en"
    }

    var currentTime : Date{
        get{
            Date()
        }
    }

    func start(){
        Paths.initPaths()
        Localizer.initialize(languages: ["en","de"])
        Application.instance.initializeData()
        ActionQueue.instance.addRegularAction(CleanupAction())
        ActionQueue.instance.start()
        Log.info("your shutdown link is 'http://\(Configuration.instance.host):\(Configuration.instance.webPort)/shutdown/\(Statics.instance.shutdownCode)'")
        HttpServer.instance.start()
    }

    func stop(){
        HttpServer.instance.stop()
        ActionQueue.instance.checkActions()
        ActionQueue.instance.stop()
    }

    func initializeData(){
        IdService.initialize()
        Statics.initialize()
        Configuration.initialize()
        UserContainer.initialize()
        ContentContainer.initialize()
        TemplateCache.initialize()
        StaticFileController.instance.ensureLayout()
    }

}

