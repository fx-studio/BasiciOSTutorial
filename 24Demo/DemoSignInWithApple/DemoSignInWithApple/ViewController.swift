//
//  ViewController.swift
//  DemoSignInWithApple
//
//  Created by Le Phuong Tien on 5/4/20.
//  Copyright © 2020 Fx Studio. All rights reserved.
//

import UIKit
import AuthenticationServices

class ViewController: UIViewController {
  
  
  
  var signInAppleButton: ASAuthorizationAppleIDButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    
//    let button = ASAuthorizationAppleIDButton()
//    button.center = view.center
//    view.addSubview(button)

    
    signInAppleButton = ASAuthorizationAppleIDButton(type: .default, style: .black)
    let frame = CGRect(x: 0, y: 0, width: 300, height: 100)
    signInAppleButton.frame = frame
    signInAppleButton.center = view.center
    signInAppleButton.addTarget(self, action: #selector(handleLoginWithApple), for: .touchUpInside)

    view.addSubview(signInAppleButton)
  }
  
  override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
    super.traitCollectionDidChange(previousTraitCollection)
    
    let hasUserInterfaceStyleChanged = traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection)
    
    if hasUserInterfaceStyleChanged {
      setupProviderLoginView()
    }
  }
  
  func setupProviderLoginView() {
    switch traitCollection.userInterfaceStyle {
    case .dark:
      let frame = signInAppleButton.frame
      signInAppleButton.removeFromSuperview()
      signInAppleButton = nil
      
      signInAppleButton = ASAuthorizationAppleIDButton(type: .default, style: .white)
      signInAppleButton.frame = frame
      view.addSubview(signInAppleButton)
      
    default:
      let frame = signInAppleButton.frame
      signInAppleButton.removeFromSuperview()
      signInAppleButton = nil
      
      signInAppleButton = ASAuthorizationAppleIDButton(type: .default, style: .black)
      signInAppleButton.frame = frame
      view.addSubview(signInAppleButton)
    }
  }
  
  @objc private func handleLoginWithApple() {
    let appleIDProvider = ASAuthorizationAppleIDProvider()
    let request = appleIDProvider.createRequest()
    request.requestedScopes = [.fullName, .email]
    
    let authorizationController = ASAuthorizationController(authorizationRequests: [request])
    authorizationController.delegate = self
    authorizationController.presentationContextProvider = self
    authorizationController.performRequests()
  }
  
}

extension ViewController : ASAuthorizationControllerPresentationContextProviding, ASAuthorizationControllerDelegate {
  
  func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
    return self.view.window!
  }
  
  func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
    if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
      guard let appleIDToken = appleIDCredential.identityToken else {
        print("Unable to fetch identity token")
        return
      }
      
      guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
        print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
        return
      }
      
      let userIdentifier = appleIDCredential.user
      let fullName = appleIDCredential.fullName
      let email = appleIDCredential.email ?? "n/a"
      
      print(idTokenString)
      print(userIdentifier)
      print(fullName)
      print(email)
    }
  }

  func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
    // Handle error.
    guard let error = error as? ASAuthorizationError else {
      return
    }
    
    switch error.code {
    case .canceled:
      print("Canceled")
    case .unknown:
      print("Unknown")
    case .invalidResponse:
      print("Invalid Respone")
    case .notHandled:
      print("Not handled")
    case .failed:
      print("Failed")
    @unknown default:
      print("Default")
    }
  }

}

