import SwiftUI
import MapKit

struct ParkingDetailView: View {
    
    // ObservedObject allows you to react to changes in the ParkingFinder object
    @ObservedObject var parkingFinder: ParkingFinder
    
    // State variables to control various aspects of the view
    @State var region: MKCoordinateRegion
    @State var showHourSelectionView = false
    @State var selectedHour: CGFloat = 0.0
    @State var animate = false
    @State var translation: CGFloat = 0.0
    @State var showShoppingMallView = false
    
    // Gesture for handling swipe
    var swipeGesture: some Gesture {
        DragGesture().onChanged { value in
            withAnimation { translation = value.translation.width }
        }
        .onEnded { value in
            if value.translation.width > 50 {
                closeCard()
            } else {
                withAnimation { translation = 0.0 }
            }
        }
    }
    
    var body: some View {
        ZStack {
            // Change background color to black
            Color.black
                .ignoresSafeArea()
                .onTapGesture { closeCard() }
            
            VStack(spacing: 10) {
                RoundedRectangle(cornerRadius: 2)
                    .fill(Color.gray)
                    .frame(width: 40, height: 4)
                    .overlay(
                        Rectangle()
                            // Change the background color to black and opacity as needed
                            .fill(Color.black.opacity(1))
                            .frame(width: UIScreen.screenWidth - 16, height: 44)
                    )
                    .gesture(swipeGesture)
                    .padding(.top, 10)
                
                Map(coordinateRegion: $region, annotationItems: [parkingFinder.selectedPlace!]) { spot in
                    MapAnnotation(coordinate: spot.location, anchorPoint: CGPoint(x: 0.5, y: 0.5)) {
                        SpotAnnotatonView(fee: "", selected: true)
                    }
                }
                .frame(height: 240)
                .cornerRadius(20)
                
                ParkingInfoView(parkingItem: parkingFinder.selectedPlace!, showSelectHourView: $showHourSelectionView, selectedHour: $selectedHour, showShoppingMallView: $showShoppingMallView)
                    .padding(.vertical, 20)
                
                PaymentView(selectedHour: $selectedHour, perHourFee: parkingFinder.selectedPlace!.fee)
                    .padding(.bottom, 20)
            }
            .padding()
            .padding(.horizontal, 20)
            .cornerRadius(20)
            .offset(y: animate ? 0 : UIScreen.screenHeight)
            .offset(x: translation)
                
            if showHourSelectionView {
                HourChangeView(selectedHour: $selectedHour, showHourSliderView: $showHourSelectionView)
            }
        }
        .onAppear {
            withAnimation { animate = true }
        }
    }
    
    func closeCard() {
        withAnimation {
            animate = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                parkingFinder.showDetail = false
                translation = 0.0
            }
        }
    }
}

