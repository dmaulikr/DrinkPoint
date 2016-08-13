//
//  GogglesViewController.swift
//  DrinkPoint
//
//  Created by Paul Kirk Adams on 6/26/16.
//  Copyright © 2016 Paul Kirk Adams. All rights reserved.
//

import UIKit
import MobileCoreServices

class GogglesViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    
    var newMedia: Bool?
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    @IBAction func useCamera(sender: AnyObject) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
            imagePicker.mediaTypes = [kUTTypeImage as NSString as String]
            imagePicker.allowsEditing = false
            self.presentViewController(imagePicker, animated: true, completion: nil)
            newMedia = true
        }
    }
    
    @IBAction func useCameraRoll(sender: AnyObject) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.SavedPhotosAlbum) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType =
                UIImagePickerControllerSourceType.PhotoLibrary
            imagePicker.mediaTypes = [kUTTypeImage as NSString as String]
            imagePicker.allowsEditing = false
            self.presentViewController(imagePicker, animated: true, completion: nil)
            newMedia = false
        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: AnyObject]) {
        let mediaType = info[UIImagePickerControllerMediaType] as! NSString
        self.dismissViewControllerAnimated(true, completion: nil)
        if mediaType.isEqualToString(kUTTypeImage as String) {
            let image = info[UIImagePickerControllerOriginalImage]
                as! UIImage
            imageView.image = image
            if (newMedia == true) {
                UIImageWriteToSavedPhotosAlbum(image, self, #selector(GogglesViewController.image(_:didFinishSavingWithError:contextInfo:)), nil)
            } else if mediaType.isEqualToString(kUTTypeMovie as String) {
                // Write code here to support video
            }
        }
    }
    
    func image(image: UIImage, didFinishSavingWithError error: NSErrorPointer, contextInfo: UnsafePointer<Void>) {
        if error != nil {
            let alert = UIAlertController(title: "Save Failed", message: "Failed to save image", preferredStyle: UIAlertControllerStyle.Alert)
            let cancelAction = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
            alert.addAction(cancelAction)
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}