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
    @State var shouldShowImagePicker = false
    
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
                            shouldShowImagePicker.toggle()
                        } label: {
                            
                            VStack {
                                
                                if let image = self.image {
                                    Image(uiImage: image)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 128, height: 128)
                                        .cornerRadius(64)
                                } else {
                                    Image(systemName: "person.fill")
                                        .font(.system(size: 64))
                                        .padding()
                                        .foregroundColor(.black)
                                }
                            }
                            .overlay(RoundedRectangle(cornerRadius: 64)
                                .stroke(.black, lineWidth: 3))
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
        .fullScreenCover(isPresented: $shouldShowImagePicker) {
            ImagePicker(image: $image)
        }
    }
    
    @State var image: UIImage?
    
    
    private func handleAction() {
        if isLoginMode {
            loginUser()
        } else {
            createNewAccount()
        }
    }
    
    @State var loginStatusMessage = ""
    
    
    private func createNewAccount() {
        FirebaseManager.shared.auth.createUser(withEmail: email, password: password) { result, error in
            if let err = error {
                self.loginStatusMessage = "Failed to signup: \(err)"
                print(loginStatusMessage)
                return
            }
            
            self.loginStatusMessage = "USER ID: \(result?.user.uid ?? "")"
            print(loginStatusMessage)
            
            self.persistImageToStorage()
        }
    }
    
    private func persistImageToStorage() {
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else {
            return
        }
        
        let ref = FirebaseManager.shared.storage.reference(withPath: uid)
        
        guard let imageData = self.image?.jpegData(compressionQuality: 0.5) else {
            return
        }
        
        ref.putData(imageData, metadata: nil) { metadata, dataError in
            if let error = dataError {
                self.loginStatusMessage = "Failed to push image to storage: \(error)"
                return
            }
            
            ref.downloadURL { url, downloadError in
                if let error = downloadError {
                    self.loginStatusMessage = "Failed to download: \(error)"
                    return
                }
                self.loginStatusMessage = "Success! \(url?.absoluteString ?? "")"
            }
        }
    }
    
    
    private func loginUser() {
        FirebaseManager.shared.auth.signIn(withEmail: email, password: password) { res, err in
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
