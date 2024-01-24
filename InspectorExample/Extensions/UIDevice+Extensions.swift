//
//  UIDevice+Extensions.swift
//  InspectorExample
//
//  Created by Concepcion Orellana on 1/22/24.
//

import UIKit

extension UIDevice {
    static var isIPad: Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }

    static var isIPhone: Bool {
        UIDevice.current.userInterfaceIdiom == .phone
    }
}
