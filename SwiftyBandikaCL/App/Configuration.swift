/*
 SwiftyBandika CMS - A Swift based Content Management System with JSON Database
 Copyright (C) 2021 Michael Roennau

 This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 3 of the License, or (at your option) any later version.
 This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
 You should have received a copy of the GNU General Public License along with this program; if not, see <http://www.gnu.org/licenses/>.
*/

import Foundation

class Configuration: DataContainer{

    static var instance = Configuration()

    static func initialize(){
        Log.info("initializing configuration")
        if !Files.fileExists(path: Paths.configFile){
            let config = Configuration()
            if !config.save(){
                Log.error("could not save default configuration")
            }
            else {
                Log.info("created default configuration")
            }
        }
        if let str = Files.readTextFile(path: Paths.configFile){
            if let config : Configuration = Configuration.fromJSON(encoded: str){
                instance = config
                Log.info("loaded app configuration")
            }
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case host
        case webPort
        case applicationName
        case autostart
        
        func placeholder() -> String{
            "[\(self.rawValue.uppercased())]"
        }
    }

    var host : String
    var webPort : Int
    var applicationName : String
    var autostart = false
    
    private let configSemaphore = DispatchSemaphore(value: 1)
    
    required init(){
        host = "localhost"
        webPort = 8080
        applicationName = "SwiftyBandika"
        super.init()
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        host = try values.decodeIfPresent(String.self, forKey: .host) ?? "localhost"
        webPort = try values.decodeIfPresent(Int.self, forKey: .webPort) ?? 0
        applicationName = try values.decodeIfPresent(String.self, forKey: .applicationName) ?? "SwiftyBandika"
        autostart = try values.decodeIfPresent(Bool.self, forKey: .autostart) ?? false
        try super.init(from: decoder)
    }
    
    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try super.encode(to: encoder)
        try container.encode(host, forKey: .host)
        try container.encode(webPort, forKey: .webPort)
        try container.encode(applicationName, forKey: .applicationName)
        try container.encode(autostart, forKey: .autostart)
    }
    
    private func lock(){
        configSemaphore.wait()
    }
    
    private func unlock(){
        configSemaphore.signal()
    }

    override func checkChanged(){
        if (changed) {
            if save() {
                Log.info("configuration saved")
                changed = false;
            }
        }
    }
    
    override func save() -> Bool{
        Log.info("saving configuration")
        lock()
        defer{unlock()}
        let json = toJSON()
        if !Files.saveFile(text: json, path: Paths.configFile){
            Log.warn("config file could not be saved")
            return false
        }
        return true
    }
    
}
