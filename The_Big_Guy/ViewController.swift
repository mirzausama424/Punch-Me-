//
//  ViewController.swift
//  The_Big_Guy
//
//  Created by Macbook on 30/04/2025.
//

import UIKit
import AVFoundation
class ViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    var audioplayer : AVAudioPlayer!
    var imagePickerController = UIImagePickerController()

    override func viewDidLoad() {
        super.viewDidLoad()
        imagePickerController.delegate = self

        // Enable user interaction on the image view
        imageView.isUserInteractionEnabled = true

        // Add tap gesture to image view
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageViewTapped))
        imageView.addGestureRecognizer(tapGesture)
    }
    
    func Audio(name : String)  {
        
        if let sound = NSDataAsset(name: name){
            do{
                try audioplayer = AVAudioPlayer(data: sound.data)
                audioplayer.play()
            }catch{
                print("Error while \(error.localizedDescription) catch while intiliztion ")
            }
        }else{
            print("Error Could not Read file  \(name)")
        }
    }

    // Function called when image is tapped
    @objc func imageViewTapped() {
        animateImageView()
    }
    
    func alert(title : String , message : String)  {
        let alertcontroller = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let actionalert = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertcontroller.addAction(actionalert)
        present(alertcontroller, animated: true, completion: nil)
    }

    
    @IBAction func uploadButton(_ sender: UIButton) {
        let alertcontroller = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let photoLibrary = UIAlertAction(title: "Photo Library", style: .default) { (_) in
            self.accesphoto()
        }
        let camera = UIAlertAction(title: "Camera", style: .default) { (_) in
            self.accescamera()
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertcontroller.addAction(photoLibrary)
        alertcontroller.addAction(camera)
        alertcontroller.addAction(cancel)
        
        present(alertcontroller, animated: true, completion: nil)
    }
    // Common animation logic
    func animateImageView() {
        let originalFrame = imageView.frame
        let widthShrink: CGFloat = 20
        let heightShrink: CGFloat = 20
        Audio(name: "Audio")

        // Shrink the image view
        let smallerFrame = CGRect(
            x: originalFrame.origin.x + widthShrink,
            y: originalFrame.origin.y + heightShrink,
            width: originalFrame.width - widthShrink * 2,
            height: originalFrame.height - heightShrink * 2
        )

        imageView.frame = smallerFrame

        // Animate back to original size
        UIView.animate(withDuration: 0.25,
                       delay: 0.0,
                       usingSpringWithDamping: 0.2,
                       initialSpringVelocity: 10,
                       options: [],
                       animations: {
            self.imageView.frame = originalFrame
        }, completion: nil)
    }
}
extension ViewController:UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editedimage = info[UIImagePickerController.InfoKey.editedImage]as? UIImage{
            imageView.image = editedimage
        }else if  let origionalimage = info[UIImagePickerController.InfoKey.originalImage]as? UIImage{
            imageView.image = origionalimage
        }
        dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    func accesphoto() {
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true, completion: nil)
    }
    func accescamera () {
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            imagePickerController.sourceType = .camera
            present(imagePickerController, animated: true, completion: nil)
        }else{
            alert(title: "Camera Not Found", message:"There is no camera aviable on this device ")
        }
    }
}


