//
//  DetailViewController.swift
//  MilestoneProject4
//
//  Created by Donny G on 07/06/2019.
//  Copyright © 2019 Donny G. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet var imageView: UIImageView!
    
    var object: CapturedObject?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        
        if let selectedObject = object {
        let path = getDocumentsDir().appendingPathComponent(selectedObject.fileName)
            imageView.image = UIImage(contentsOfFile: path.path)
            imageView.contentMode = .scaleAspectFill
        }
    }
    
    func getDocumentsDir()-> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
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
