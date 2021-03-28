//
//  main.swift
//  SwiftyBandikaCL
//
//  Created by Michael Rönnau on 28.03.21.
//

import Foundation

Application.instance.start()
defer {
    Application.instance.stop()
}