import SwiftUI

struct LineGraph: View {
    let data: [Double]
    let lineColor: Color
    @Binding var selectedDataIndex: Int?
    let glowColor: Color

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Prediction Line
                if data.count > 1 {
                    Path { path in
                        //  prediction line from the last visible point on the graph
                        let lastVisibleIndex = min(data.count - 1, 3) // (limited to 3)
                        let xStart = CGFloat(lastVisibleIndex) * (geometry.size.width - 40) / CGFloat(data.count - 1) + 20
                        let yStart = (geometry.size.height - 40) * CGFloat(1 - data[lastVisibleIndex] / data.max()!) + 20
                        path.move(to: CGPoint(x: xStart, y: yStart))

                        // Continue the prediction line to the end of the graph
                        let xEnd = geometry.size.width - 20
                        let yEnd = (geometry.size.height - 40) * CGFloat(1 - data[0] / data.max()!) + 20
                        path.addLine(to: CGPoint(x: xEnd, y: yEnd))
                    }
                    .stroke(lineColor.opacity(0.5), style: StrokeStyle(lineWidth: 2, dash: [5]))
                }

                //  Line Graph
                Path { path in
                    for (index, value) in data.enumerated() {
                        if index < 4 { // Stop at day 4
                            let x = CGFloat(index) * (geometry.size.width - 40) / CGFloat(data.count - 1) + 20
                            let y = (geometry.size.height - 40) * CGFloat(1 - value / data.max()!) + 20
                            if index == 0 {
                                path.move(to: CGPoint(x: x, y: y))
                            } else {
                                path.addLine(to: CGPoint(x: x, y: y))
                            }
                        }
                    }
                }
                .stroke(lineColor, lineWidth: 2)

                // Dots on the Line Graph
                ForEach(data.indices, id: \.self) { index in
                    if index < 4 { // Stop at day 4
                        Circle()
                            .fill(selectedDataIndex == index ? glowColor : Color.clear)
                            .frame(width: 16, height: 16)
                            .position(
                                x: CGFloat(index) * (geometry.size.width - 40) / CGFloat(data.count - 1) + 20,
                                y: (geometry.size.height - 40) * CGFloat(1 - data[index] / data.max()!) + 20
                            )
                            .onTapGesture {
                                withAnimation {
                                    selectedDataIndex = index
                                }
                            }
                    }
                }
            }
        }
    }
}

struct UsageGraph: View {
    let data: [Double]
    let isGraphVisible: Binding<Bool>
    let lineColor: Color = Color.green
    let glowColor: Color = Color.green.opacity(0.5)
    let dotSize: CGFloat = 12

    @State private var selectedDataIndex: Int?

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.gray.opacity(0.1))
                    .frame(width: geometry.size.width + 50, height: geometry.size.height - 2)

                LineGraph(data: data, lineColor: lineColor, selectedDataIndex: $selectedDataIndex, glowColor: glowColor)
                    .frame(width: geometry.size.width - 20, height: geometry.size.height - 10)
                    .offset(x: -15, y: 20)

                HStack {
                    ForEach(0..<min(data.count, 4), id: \.self) { index in
                        Text("Day \(index + 1)")
                            .font(.caption)
                            .foregroundColor(.white)
                            .frame(width: (geometry.size.width - 60) / CGFloat(data.count - 1), alignment: .center)
                            .offset(x: -25, y: -50)
                    }
                }
                .offset(y: geometry.size.height - 40)

                VStack(alignment: .trailing) {
                    Spacer()
                    ForEach((1...4).reversed(), id: \.self) { value in
                        Text("\(Int(value * 20))%")
                            .font(.caption)
                            .foregroundColor(.white)
                            .frame(height: (geometry.size.height - 40) / 5, alignment: .trailing)
                            .offset(x: -200)
                    }
                }
            }
        }
    }
}

struct UsageGraph_Previews: PreviewProvider {
    static var previews: some View {
        UsageGraph(data: [20, 50, 55, 85, 20], isGraphVisible: .constant(true))
            .frame(height: 200)
    }
}

