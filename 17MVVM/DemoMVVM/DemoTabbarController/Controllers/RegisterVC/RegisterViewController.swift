//
//  RegisterViewController.swift
//  DemoMVVM
//
//  Created by Tien Le P. on 7/12/18.
//  Copyright © 2018 Tien Le P. All rights reserved.
//

import UIKit
import AVFoundation

class RegisterViewController: BaseViewController {
    
    // MARK: - Properties
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var brithdayTextField: UITextField!
    
    var viewModel = RegisterViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: config
    override func setupUI() {
        super.setupUI()
        self.title = "Register new account"
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done",
                                                                style: .done,
                                                                target: self,
                                                                action: #selector(register))

    }
    
    override func setupData() {
    }
    
    func updateView() {
        nameTextField.text = viewModel.name
        emailTextField.text = viewModel.email
        passwordTextField.text = viewModel.password
        brithdayTextField.text = viewModel.brithday
    }
    
    // MARK: - register
    @objc func register() {
        print("register")
        viewModel.register { (result) in
            switch result {
            case .success:
                print("OK")
                self.updateView() //làm cái gi đó
            case .failure(let error):
                print("error: \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: - Actions
    @IBAction func avatarButtonTouchUpInside(_ sender: Any) {
        showActionsheet()
    }
}

// MARK: - Actionsheet
extension RegisterViewController {

    func showActionsheet() {
        let alertController = UIAlertController(title: "Choice photo", message: "", preferredStyle: .actionSheet)
        
        let sendButton = UIAlertAction(title: "Gallery", style: .default, handler: { (action) -> Void in
            print("Gallery button tapped")
            self.showGallery()
        })
        
        let  cameraButton = UIAlertAction(title: "Camera", style: .default, handler: { (action) -> Void in
            print("Camera button tapped")
            self.showCamera()
        })
        
        let  deleteButton = UIAlertAction(title: "Delete", style: .destructive, handler: { (action) -> Void in
            print("Delete button tapped")
            self.deleteAvatarImage()
        })
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) -> Void in
            print("Cancel button tapped")
        })
        
        
        alertController.addAction(sendButton)
        alertController.addAction(cameraButton)
        alertController.addAction(deleteButton)
        alertController.addAction(cancelButton)
        
        self.navigationController!.present(alertController, animated: true, completion: nil)
    }
    
}

// MARK: - Image Picker View
extension RegisterViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func showGallery() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        self.navigationController?.present(imagePickerController, animated: true, completion: nil)
    }
    
    func showCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePickerController = UIImagePickerController()
            imagePickerController.sourceType = .camera
            imagePickerController.cameraCaptureMode = .photo
            imagePickerController.modalPresentationStyle = .fullScreen
            present(imagePickerController, animated: true,completion: nil)
        } else {
            noCamera()
        }
    }
    
    func noCamera(){
        let alertVC = UIAlertController(title: "No Camera", message: "Sorry, this device has no camera", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style:.default, handler: nil)
        alertVC.addAction(okAction)
        present(alertVC, animated: true, completion: nil)
    }
    
    func deleteAvatarImage() {
        self.avatarImageView.image = UIImage(named: "img_bg_no_avatar")
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        var newImage: UIImage
        
        if let possibleImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            newImage = possibleImage
        } else if let possibleImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            newImage = possibleImage
        } else {
            return
        }
        
        // do something interesting here!
        self.avatarImageView.image = newImage
        
        dismiss(animated: true)
    }
}


