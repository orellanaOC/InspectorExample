//
//  Array+Extensions.swift
//  InspectorExample
//
//  Created by Concepcion Orellana on 10/1/23.
//

import Foundation

extension Array where Element == Fruit {
    var groupID: Fruit.ID {
        reduce("") { result, next in
            result.appending(next.id)
        }
    }
}
