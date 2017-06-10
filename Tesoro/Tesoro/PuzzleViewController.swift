//
//  PuzzleViewController.swift
//  Tesoro
//
//  Created by Lucy on 2017/6/10.
//  Copyright © 2017年 Cu. All rights reserved.
//

import UIKit
import ImagePicker


class PuzzleViewController: UIViewController, ImagePickerDelegate {

    @IBAction func openCamera(_ sender: Any) {
        
        print("camera")
        
    }
    
    @IBOutlet weak var cameraButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    func openCamera() {
        
        print("camera")
        
    }
    
    func setupViewController() {
    
        
    
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let imagePickerController = ImagePickerController()
        imagePickerController.imageLimit = 1
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        
    }
    func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        
    }
    func cancelButtonDidPress(_ imagePicker: ImagePickerController) {
        
    }

}
