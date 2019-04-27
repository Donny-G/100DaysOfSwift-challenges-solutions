//
//  DetailViewController.swift
//  Project1
//
//  Created by Donny G on 27/02/2019.
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
        
        if let imageToSelect = selectedImage {
            imageView.image = UIImage(named: imageToSelect)
    }
        
}
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.hidesBarsOnTap = true
}
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        navigationController?.hidesBarsOnTap = false
}

}
    


