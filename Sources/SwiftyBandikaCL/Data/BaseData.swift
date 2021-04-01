/*
 SwiftyBandika CMS - A Swift based Content Management System with JSON Database
 Copyright (C) 2021 Michael Roennau

 This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 3 of the License, or (at your option) any later version.
 This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
 You should have received a copy of the GNU General Public License along with this program; if not, see <http://www.gnu.org/licenses/>.
*/

import Foundation

class BaseData: TypedData, Identifiable, Codable, Hashable{
    
    static func == (lhs: BaseData, rhs: BaseData) -> Bool {
        lhs.id == rhs.id && lhs.version == rhs.version
    }
    
    private enum BaseDataCodingKeys: CodingKey{
        case id
        case version
        case creationDate
        case changeDate
        case creatorId
        case changerId
    }
    
    var id: Int
    var version: Int
    var creationDate: Date
    var changeDate: Date
    var creatorId: Int
    var changerId: Int
    
    var isNew = false

    var type : DataType{
        get {
            .base
        }
    }
    
    init(){
        isNew = false
        id = 0
        version = 1
        creationDate = Date()
        changeDate = Date()
        creatorId = 1
        changerId = 1
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: BaseDataCodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id) ?? 0
        version = try values.decodeIfPresent(Int.self, forKey: .version) ?? 1
        creationDate = try values.decodeIfPresent(Date.self, forKey: .creationDate) ?? Date()
        changeDate = try values.decodeIfPresent(Date.self, forKey: .changeDate) ?? Date()
        creatorId = try values.decodeIfPresent(Int.self, forKey: .creatorId) ?? 1
        changerId = try values.decodeIfPresent(Int.self, forKey: .changerId) ?? 1
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: BaseDataCodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(version, forKey: .version)
        try container.encode(creationDate, forKey: .creationDate)
        try container.encode(changeDate, forKey: .changeDate)
        try container.encode(creatorId, forKey: .creatorId)
        try container.encode(changerId, forKey: .changerId)
    }
    
    func hash(into hasher: inout Hasher){
        hasher.combine(id)
        hasher.combine(version)
    }
    
    func copyFixedAttributes(from data: TypedData) {
        if let baseData = data as? BaseData {
            id = baseData.id
            creationDate = baseData.creationDate
            creatorId = baseData.creatorId
        }
    }
    
    func copyEditableAttributes(from data: TypedData) {
        if let baseData = data as? BaseData {
            version = baseData.version
            changeDate = baseData.changeDate
            changerId = baseData.changerId
        }
    }
    
    func increaseVersion() {
        version += 1;
    }
    
    func readRequest(_ request: Request) {
    }
    
    func setCreateValues(request: Request) {
        isNew = true
        id = IdService.instance.getNextId()
        version = 1
        creatorId = request.userId
        creationDate = Application.instance.currentTime
        changerId = request.userId
        changeDate = creationDate
    }
    
    func isEqualByIdAndVersion(data: BaseData) -> Bool{
        id == data.id && version == data.version
    }
    
    func prepareDelete(){
    }
    
    func isComplete() -> Bool{
        true
    }
    
}

