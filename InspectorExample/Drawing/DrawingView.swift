//
//  DrawingView.swift
//  DrawingApp
//
//  Created by Karin Prater on 18.06.21.
//

import SwiftUI

struct DrawingView: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass

    @State private var lines = [Line]()
    @State private var deletedLines = [Line]()
    @State private var selectedColor: Color = .black
    @State private var selectedLineWidth: CGFloat = 1
    @State private var showConfirmation: Bool = false

    let engine = DrawingEngine()
    let isInsideOfTheInspector: Bool

    var showInspector: Binding<Bool>

    var body: some View {
        VStack {
            ZStack {

                Color.white
                
                ForEach(lines){ line in
                    DrawingShape(points: line.points)
                        .stroke(line.color, style: StrokeStyle(lineWidth: line.lineWidth, lineCap: .round, lineJoin: .round))
                }
            }
            .gesture(DragGesture(minimumDistance: 0, coordinateSpace: .local).onChanged({ value in
                let newPoint = value.location
                if value.translation.width + value.translation.height == 0 {
                    //TODO: use selected color and linewidth
                    lines.append(Line(points: [newPoint], color: selectedColor, lineWidth: selectedLineWidth))
                } else {
                    let index = lines.count - 1
                    lines[index].points.append(newPoint)
                }

            }).onEnded({ value in
                if let last = lines.last?.points, last.isEmpty {
                    lines.removeLast()
                }
            })

            )

        }
        .inspector(isPresented: showInspector) {
            VStack {
                HStack {
                    ColorPicker("line color", selection: $selectedColor)
                        .labelsHidden()

                    Spacer()

                    Slider(value: $selectedLineWidth, in: 1...20) {
                        Text("linewidth")
                    }
                    .frame(maxWidth: 150)
                    .padding()

                    Text(String(format: "%.0f", selectedLineWidth))
                        .font(.title2)
                        .foregroundStyle(.gray)
                        .padding()
                }

                Spacer()

                HStack {
                    Button {
                        let last = lines.removeLast()
                        deletedLines.append(last)
                    } label: {
                        Image(systemName: "arrow.uturn.backward.circle")
                            .imageScale(.large)
                    }
                    .disabled(lines.count == 0)

                    Button {
                        let last = deletedLines.removeLast()

                        lines.append(last)
                    } label: {
                        Image(systemName: "arrow.uturn.forward.circle")
                            .imageScale(.large)
                    }
                    .disabled(deletedLines.count == 0)

                    Spacer()
                    Button(action: {
                        lines = [Line]()
                        deletedLines = [Line]()
                    }) {
                        Text("Delete")
                            .font(.title2)
                    }
                    .foregroundColor(.red)
                }
                .padding()
            }
            .padding()
            .presentationDetents([.height(200), .medium, .large])
            .presentationBackgroundInteraction(.enabled(upThrough: .height(200)))

//    MARK: - Inside navigation structure - Toolbar content inside inspector
            .toolbar {
                if isInsideOfTheInspector {
                    Button {
                        showInspector.wrappedValue.toggle()
                    } label: {
                        Label("Toggle Inspector", systemImage: "info.circle")
                    }
                }
            }
        }

//    MARK: - Inside navigation structure - Toolbar content outside inspector
        .toolbar {
            if !isInsideOfTheInspector || horizontalSizeClass == .compact {
                Button {
                    showInspector.wrappedValue.toggle()
                } label: {
                    Label("Toggle Inspector", systemImage: "info.circle")
                }
            }
        }
    }
}

struct DrawingView_Previews: PreviewProvider {
    static var previews: some View {
        DrawingView(
            isInsideOfTheInspector: true,
            showInspector: .constant(true)
        )
    }
}
