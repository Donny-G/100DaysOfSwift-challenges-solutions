//
//  ViewController.swift
//  Project 13
//
//  Created by DeNNiO   G on 15/06/2019.
//  Copyright © 2019 Donny G. All rights reserved.
//

import UIKit
import  CoreImage

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var intensity: UISlider!
    @IBOutlet var intensity2: UISlider!
    @IBOutlet var radius: UISlider!
    @IBOutlet var changeFilterButton: UIButton!
    
    var currentImage: UIImage!
    var context: CIContext!
    var currentFilter: CIFilter! {
        didSet {
            let currentFilterName = currentFilter.name
            changeFilterButton.setTitle("Change Filter (\(currentFilterName))", for: .normal)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "YACIFP"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(importPicture))
        
        context = CIContext()
        currentFilter = CIFilter(name: "CISepiaTone")
    }
    
    @objc func importPicture(){
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[.editedImage] as? UIImage else {return}
        dismiss(animated: true)
        
        currentImage = image
        let beginImage = CIImage(image: currentImage)
        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
        applyProcessing()
    }

    @IBAction func changeFilter(_ sender: Any) {
        let ac = UIAlertController(title: "Choose filter", message: nil, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "CIBumpDistortion", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CIGaussianBlur", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CIPixellate", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CISepiaTone", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CITwirlDistortion", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CIUnsharpMask", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CIVignette", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
    
    func setFilter(action: UIAlertAction){
        guard currentImage != nil else {return}
        guard let actionTitle = action.title else {return}
        currentFilter = CIFilter(name: actionTitle)
        let beginImage = CIImage(image: currentImage)
        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
        radius.isEnabled = true
        applyProcessing()
    }
    
    @IBAction func save(_ sender: Any) {
        guard let image = imageView.image else {let ac = UIAlertController(title: "Error", message: "Please load the image at first", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Ok", style: .default))
            present(ac, animated: true)
            return}
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    @IBAction func intensityChanged(_ sender: Any) {
        applyProcessing()
    }
    
    @IBAction func intensity2Changed(_ sender: Any) {
        applyProcessing2()
    }
    
    @IBAction func radiusChanged(_ sender: Any) {
        applyProcessing3()
    }
    
    func applyProcessing(){
        let inputKeys  = currentFilter.inputKeys
        if inputKeys.contains(kCIInputIntensityKey) {currentFilter.setValue(intensity.value, forKey: kCIInputIntensityKey)}
        if inputKeys.contains(kCIInputRadiusKey) {currentFilter.setValue(intensity.value * 100, forKey: kCIInputRadiusKey)}
        if inputKeys.contains(kCIInputScaleKey) {currentFilter.setValue(intensity.value * 5, forKey: kCIInputScaleKey)}
        if inputKeys.contains(kCIInputCenterKey) {currentFilter.setValue(CIVector(x: currentImage.size.width / 2, y: currentImage.size.height / 2), forKey: kCIInputCenterKey)}
        
        guard currentImage != nil else {let ac = UIAlertController(title: "Error", message: "Please load the image at first", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Ok", style: .default))
            present(ac, animated: true)
            return}
        
        if let cgimg = context.createCGImage(currentFilter.outputImage!, from: currentFilter.outputImage!.extent){
            let processedImage = UIImage(cgImage: cgimg)
            imageView.image = processedImage
        }
    }
    
    func applyProcessing2(){
        let inputKeys  = currentFilter.inputKeys
        if inputKeys.contains(kCIInputIntensityKey) {currentFilter.setValue(intensity.value * 10, forKey: kCIInputIntensityKey)}
        if inputKeys.contains(kCIInputScaleKey) {currentFilter.setValue(intensity.value * 10, forKey: kCIInputScaleKey)}
        if inputKeys.contains(kCIInputCenterKey) {currentFilter.setValue(CIVector(x: currentImage.size.width / 4, y: currentImage.size.height / 4), forKey: kCIInputCenterKey)}
        
        guard currentImage != nil else {let ac = UIAlertController(title: "Error", message: "Please load the image at first", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Ok", style: .default))
            present(ac, animated: true)
            return}
        
        if let cgimg = context.createCGImage(currentFilter.outputImage!, from: currentFilter.outputImage!.extent){
            let processedImage = UIImage(cgImage: cgimg)
            imageView.image = processedImage
        }
    }
    
    func applyProcessing3(){
        let inputKeys  = currentFilter.inputKeys
        if inputKeys.contains(kCIInputRadiusKey) {currentFilter.setValue(intensity.value * 300, forKey: kCIInputRadiusKey)
        }else{
            let ac = UIAlertController(title: "Slider is not applicable with this filter", message: nil, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Ok", style: .cancel))
            present(ac, animated: true)
            radius.isEnabled = false
        }
        if inputKeys.contains(kCIInputAngleKey) {
            currentFilter.setValue(intensity.value * 3, forKey: kCIInputAngleKey)
        }
        
        guard currentImage != nil else {let ac = UIAlertController(title: "Error", message: "Please load the image at first", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Ok", style: .default))
            present(ac, animated: true)
            return}
        
        if let cgimg = context.createCGImage(currentFilter.outputImage!, from: currentFilter.outputImage!.extent){
            let processedImage = UIImage(cgImage: cgimg)
            imageView.image = processedImage
        }
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer){
        if let error = error {
            let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Ok", style: .default))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "Saved!", message: "Your altered image has been saved to your photo library", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Ok", style: .default))
            present(ac, animated: true)
        }
    }
    
}

