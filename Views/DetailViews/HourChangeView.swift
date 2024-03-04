import SwiftUI

struct HourChangeView: View {
    
    @Binding var selectedHour: CGFloat
    @Binding var showHourSliderView: Bool
    
    var body: some View {
        ZStack {
            // Background with blur
            Color.black.opacity(0.1)
                .ignoresSafeArea()
                .blur(radius: 10) // Adjust the blur radius as needed
            
            GeometryReader { geometry in
                VStack {
                    Text("Choose Hour (max: 6 hours)")
                        .foregroundColor(.white)
                        .bold()
                    
                    // Hour change slider
                    HourSliderView(
                        progress: $selectedHour,
                        showHourSlider: $showHourSliderView,
                        width: geometry.size.width
                    )
                }
            }
            .frame(height: 80)
            .padding(20)
            .background(
                // Background with blur
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color.black)
                    .opacity(0.8) // Adjust the opacity as needed
                    .blur(radius: 10) // Adjust the blur radius as needed
            )
            .offset(y: -135)
        }
        .cornerRadius(15)
    }
}

