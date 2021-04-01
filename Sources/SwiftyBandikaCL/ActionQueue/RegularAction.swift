/*
 SwiftyBandika CMS - A Swift based Content Management System with JSON Database
 Copyright (C) 2021 Michael Roennau

 This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 3 of the License, or (at your option) any later version.
 This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
 You should have received a copy of the GNU General Public License along with this program; if not, see <http://www.gnu.org/licenses/>.
*/

import Foundation

class RegularAction : QueuedAction{

    var nextExecution:  Date

    override init(){
        nextExecution = Application.instance.currentTime
        super.init()
    }

    var intervalMinutes : Int{
        get{
            return 0
        }
    }

    var isActive : Bool{
        get{
            intervalMinutes != 0
        }
    }

    // other methods

    func checkNextExecution() {
        if isActive{
            let now = Application.instance.currentTime
            let next = nextExecution
            if now > next {
                ActionQueue.instance.addAction(self)
                let seconds = intervalMinutes * 60
                nextExecution = now + Double(seconds)
            }
        }
    }

}
