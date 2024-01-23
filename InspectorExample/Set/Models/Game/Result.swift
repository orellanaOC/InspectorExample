//
//  Result.swift
//  SetGame
//
//  Created by Concepcion Orellana on 4/20/22.
//

import Foundation

struct Result {
    var isSetOfColors = false
    var isSetOfNumberOfShapes = false
    var isSetOfShadings = false
    var isSetOfShapes = false

    var isCompleteSet: Bool {
        isSetOfColors && isSetOfNumberOfShapes && isSetOfShadings && isSetOfShapes
    }
}
