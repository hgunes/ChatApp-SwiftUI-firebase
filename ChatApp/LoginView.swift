//
//  ContentView.swift
//  ChatApp
//
//  Created by Harun Gunes on 25/07/2022.
//

import SwiftUI
import Firebase

struct LoginView: View {
    
    @State var isLoginMode = false
    @State var email = ""
    @State var password = ""
    
    init() {
        FirebaseApp.configure()
    }


    var body: some View {
        
        NavigationView {
            ScrollView {
                VStack(spacing: 16) {
                    Picker(selection: $isLoginMode, label: Text("Picker here")) {
                        Text("Login")
                            .tag(true)
                        Text("Create account")
                            .tag(false)
                    }.pickerStyle(SegmentedPickerStyle())
                        .padding()
                    
                    if !isLoginMode {
                        Button {
                            
                        } label: {
                            Image(systemName: "person.fill")
                                .font(.system(size: 64))
                                .padding()
                        }
                    }
                    
                    Group {
                        TextField("Email", text: $email)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                        
                        SecureField("Password", text: $password)
                    }
                    .padding(12)
                    .background(.white)
                    .cornerRadius(10)
                    
                    Button {
                        handleAction()
                    } label: {
                        HStack {
                            Spacer()
                            Text(isLoginMode ? "Login" : "Create account")
                                .foregroundColor(.white)
                                .padding(.vertical, 8)
                                .font(.system(size: 14, weight: .semibold))
                            Spacer()
                        }
                    }.background(.blue)
                        .cornerRadius(10)
                }
                .padding()
            }
            .navigationTitle(isLoginMode ? "Login" : "Create account")
            .background(Color(.init(white: 0, alpha: 0.05))
                .ignoresSafeArea())
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    
    private func handleAction() {
        if isLoginMode {
            loginUser()
        } else {
            createNewAccount()
        }
    }
    
    @State var loginStatusMessage = ""
    
    
    private func createNewAccount() {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let err = error {
                self.loginStatusMessage = "Failed to signup: \(err)"
                print(loginStatusMessage)
                return
            }
            
            self.loginStatusMessage = "USER ID: \(result?.user.uid ?? "")"
            print(loginStatusMessage)
        }
    }
    
    
    private func loginUser() {
        Auth.auth().signIn(withEmail: email, password: password) { res, err in
            if let err = err {
                self.loginStatusMessage = "Failed to login: \(err)"
                print(loginStatusMessage)
                return
            }
            
            self.loginStatusMessage = "Logged in as  \(res?.user.uid ?? "")"
            print(loginStatusMessage)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
            .previewInterfaceOrientation(.portrait)
    }
}
