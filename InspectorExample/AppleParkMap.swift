//
//  AppleParkMap.swift
//  InspectorExample
//
//  Created by Concepcion Orellana on 6/23/23.
//

import SwiftUI
import MapKit

@available(iOS 17.0, *)
struct AppleParkMap: View {
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(
            latitude: 37.334_371,
            longitude: -122.009_558
        ),
        latitudinalMeters: 100,
        longitudinalMeters: 100
    )

    var body: some View {
        GeometryReader { geometry in
            Map(
                position: .constant(.automatic),
                bounds: .init(
                    centerCoordinateBounds: region,
                    minimumDistance: 100,
                    maximumDistance: 100
                ),
                interactionModes: [],
                scope: .none
            ) { }
        }
        .frame(height: 180, alignment: .center)
    }
}

#Preview {
    AppleParkMap()
}
