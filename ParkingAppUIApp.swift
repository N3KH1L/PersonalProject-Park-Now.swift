import SwiftUI

@main
struct ParkingAppUIApp: App {
    @State private var showContentView = false

    var body: some Scene {
        WindowGroup {
            if showContentView {
                ContentView()
            } else {
                LaunchScreenView()
                    .onAppear {
                        // Simulating a delay before transitioning to ContentView
                        DispatchQueue.main.asyncAfter(deadline: .now() + 100) {
                            withAnimation {
                                showContentView = true
                            }
                        }
                    }
            }
        }
    }
}

