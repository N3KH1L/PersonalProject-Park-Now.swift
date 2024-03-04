import SwiftUI

struct HourSliderView: View {
    
    @Binding var progress: CGFloat
    @Binding var showHourSlider: Bool
    @State var knobPosition: CGFloat = 0.0
    
    let sliderConfig = HourSliderConfig()
    let width: CGFloat
        
    var dragGesture: some Gesture {
        DragGesture(minimumDistance: 0.0)
            .onChanged { value in
                // calculate progress width
                calculateProgressWidth(xLocation: value.location.x)
            }
            .onEnded { value in
                // calculate step
                calculateStep(xLocation: value.location.x)
                showHourSlider = false
            }
    }
    
    var body: some View {
        ZStack(alignment: .leading) {
            HStack(alignment: .bottom) {
                ForEach(Array(stride(from: 0, to: 12, by: 1)), id: \.self) { i in
                    Rectangle()
                        .fill(Color.white)
                        .frame(width: 5, height: i%2 == 0 ? 9 : 5)
                    if i != 11 {
                        Spacer()
                    }
                }
            }
                
            RoundedRectangle(cornerRadius: 5)
                .fill(LinearGradient(gradient: Gradient(colors: [Color.green, Color.green]), startPoint: .leading, endPoint: .trailing))
                .frame(width: knobPosition, height: 9)
                .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(Color.white, lineWidth: 0)
                )
                
            Circle()
                .fill(LinearGradient(gradient: Gradient(colors: [Color.green, Color.green]), startPoint: .leading, endPoint: .trailing))
                .frame(width: 26, height: 26)
                .padding(12)
                .offset(x: -22)
                .offset(x: knobPosition)
                .gesture(dragGesture)
        }
        .onAppear {
            calculateInitialKnobPosition()
        }
    }
    
    func calculateInitialKnobPosition() {
        progress = sliderConfig.minimumValue
        knobPosition = (progress / sliderConfig.maximumValue) * width
    }
        
    func calculateProgressWidth(xLocation: CGFloat) {
        let tempProgress = xLocation/width
        if tempProgress >= 0 && tempProgress <= 1 {
            let roundedProgress = (tempProgress * (sliderConfig.maximumValue - sliderConfig.minimumValue)) + sliderConfig.minimumValue
            progress = roundedProgress
            knobPosition = tempProgress * width
        }
    }
        
    func calculateStep(xLocation: CGFloat) {
        let tempProgress = xLocation/width
        if tempProgress >= 0 && tempProgress <= 1 {
            let roundedProgress = (tempProgress * (sliderConfig.maximumValue - sliderConfig.minimumValue)) + sliderConfig.minimumValue
            progress = roundedProgress
            knobPosition = tempProgress * width
        }
    }
}

struct HourSliderConfig {
    let minimumValue: CGFloat = 0.0
    let maximumValue: CGFloat = 12.0
    let knobRadius: CGFloat = 22.0
}

