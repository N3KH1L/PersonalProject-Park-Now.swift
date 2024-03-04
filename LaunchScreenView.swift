import SwiftUI

struct LaunchScreenView: View {
    @State private var username = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var showSignup = false
    @State private var tempCredentialsGenerated = false
    @State private var tempUsername = ""
    @State private var tempPassword = ""
    @State private var isLoggedIn = false // Added state to track login status

    var body: some View {
        NavigationView { // Wrap everything in NavigationView
            VStack {
                Image("image_1") //logo image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 150, height: 150)
                    .padding(.top, 50)

                if showSignup {
                    Text("Sign Up")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                        .padding(.top, 30)
                } else {
                    Text("Welcome Back")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                        .padding(.top, 30)
                }

                if !showSignup {
                    Text("Sign in to continue")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .padding(.top, 5)
                }

                VStack(spacing: 20) {
                    TextField("Username", text: $username)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                        .padding(.horizontal)

                    SecureField("Password", text: $password)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                        .padding(.horizontal)

                    if showSignup {
                        SecureField("Confirm Password", text: $confirmPassword)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                            .padding(.horizontal)
                    }
                }
                .padding(.horizontal, 30)
                .padding(.top, 50)

                if !showSignup {
                    Button(action: {
                        // Implement login logic here
                        // For demo, let's check if username and password match some demo credentials
                        if username == "Demo" && password == "1234" {
                            // Successful login
                            isLoggedIn = true
                            print("Login successful")
                        } else {
                            // Failed login
                            print("Login failed")
                        }
                    }) {
                        Text("Sign In")
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .cornerRadius(8)
                            .padding(.horizontal, 30)
                    }
                    .padding(.top, 30)
                } else {
                    Button(action: {
                        // Implement sign-up logic here
                        if password == confirmPassword {
                            // Successful sign-up
                            print("Sign up successful")
                        } else {
                            // Passwords don't match
                            print("Passwords don't match")
                        }
                    }) {
                        Text("Sign Up")
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .cornerRadius(8)
                            .padding(.horizontal, 30)
                    }
                    .padding(.top, 30)
                }
                
                // Button for going back to login page
                if showSignup {
                    Button(action: {
                        // Go back to the login page
                        showSignup.toggle()
                    }) {
                        Text("Back to Login")
                            .foregroundColor(.blue)
                            .padding(.top, 20)
                    }
                }

                if !showSignup {
                    Button(action: {
                        // Generate temporary credentials
                        tempUsername = generateRandomString(length: 8)
                        tempPassword = generateRandomString(length: 8)
                        tempCredentialsGenerated = true
                    }) {
                        Text("Forgot Password?")
                            .foregroundColor(.blue)
                            .padding(.top, 20)
                    }

                    if tempCredentialsGenerated {
                        Text("Temporary Username: \(tempUsername)")
                            .padding(.top, 20)
                        Text("Temporary Password: \(tempPassword)")
                    }
                }

                Spacer()

                HStack {
                    if !showSignup {
                        Text("Don't have an account?")
                            .foregroundColor(.gray)
                        Button(action: {
                            showSignup.toggle()
                        }) {
                            Text("Sign Up")
                                .foregroundColor(.blue)
                        }
                    }
                }
                .padding(.bottom, 30)
            }
            .padding(.horizontal)
            .background(Color(.systemBackground)) // Set background color
            .navigationBarHidden(true) // Hide navigation bar
            .onAppear {
                isLoggedIn = UserDefaults.standard.bool(forKey: "isLoggedIn") // Check if user is logged in
            }
            .onChange(of: isLoggedIn) { newValue in
                if newValue {
                    // If logged in, navigate to ContentView
                    navigateToContentView()
                }
            }
        }
    }

    func generateRandomString(length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).map{ _ in letters.randomElement()! })
    }

    func navigateToContentView() {
        // Navigate to ContentView
        let contentView = ContentView()
        UIApplication.shared.windows.first?.rootViewController = UIHostingController(rootView: contentView)
        UIApplication.shared.windows.first?.makeKeyAndVisible()
    }
}

struct LaunchScreenView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchScreenView()
    }
}

