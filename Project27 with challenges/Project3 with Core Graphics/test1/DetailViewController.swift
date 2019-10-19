//
//  DetailViewController.swift
//  test1
//
//  Created by Donny G  on 28/02/2019.
//  Copyright © 2019 Donny G. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet var imageView: UIImageView!
    var selectedImage: String?
    var totalPictures = 0
    var positionOfSelectedImage = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Picture \(positionOfSelectedImage) of \(totalPictures)"
        navigationItem.largeTitleDisplayMode = .never
       
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(tappedSharing))
       
        
        if let imageToSelect = selectedImage {
            imageView.image = UIImage(named: imageToSelect)
        }
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.hidesBarsOnTap = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        navigationController?.hidesBarsOnTap = false
    }
    
    @objc func tappedSharing() {
        //Challenge 3
        guard let imageSize = imageView.image?.size else {return}
        guard let image = imageView.image else {
            print("No image")
            return
        }
        let renderer = UIGraphicsImageRenderer(size: imageSize)
        let img = renderer.image { ctx in
            image.draw(at: CGPoint(x: 0, y: 0))
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .left
            
            let attrs: [NSAttributedString.Key: Any] = [ .font: UIFont.systemFont(ofSize: 20), .paragraphStyle: paragraphStyle, .foregroundColor: UIColor.red]
            
            let string = "From Storm Viewer"
            let attributedString = NSAttributedString(string: string, attributes: attrs)
            
            attributedString.draw(with: CGRect(x: 5, y: 5, width: 300, height: 300), options: .usesLineFragmentOrigin, context: nil)
            
        }
        
        
        let vc = UIActivityViewController(activityItems: [img.jpegData(compressionQuality: 1) as Any, selectedImage!], applicationActivities: [])
        
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
