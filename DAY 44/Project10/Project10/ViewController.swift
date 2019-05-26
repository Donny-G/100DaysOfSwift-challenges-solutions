//
//  ViewController.swift
//  Project10
//
//  Created by Donny G. on 25/05/2019.
//  Copyright © 2019 Donny G. All rights reserved.
//

import UIKit

class ViewController: UICollectionViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var people = [Person]()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewPerson))
    }
    
    @objc func addNewPerson (){
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.sourceType = .camera }
        else {
            picker.sourceType = .photoLibrary
        }
        present(picker,animated: true)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return people.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Person", for: indexPath) as? PersonCell else {
            fatalError("Unable to dequeue PersonalCell")
        }
        
        let person = people[indexPath.item]
        cell.name.text = person.name
        let path = getDocumentsDirectory().appendingPathComponent(person.image)
        cell.imageView.image = UIImage(contentsOfFile: path.path)
        
        cell.imageView.layer.borderColor = UIColor(white: 0, alpha: 0.3).cgColor
        cell.imageView.layer.borderWidth = 3
        cell.imageView.layer.cornerRadius = 10
        cell.layer.cornerRadius = 10
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let person = people[indexPath.item]
        
        if person.name == "Unknown"{
        
        let ac1 = UIAlertController(title: "Rename", message: nil, preferredStyle: .alert)
        ac1.addTextField()
        ac1.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        ac1.addAction(UIAlertAction(title: "Submit", style: .default){ [weak self, weak ac1] _ in
            guard let newName = ac1?.textFields?[0].text else {return}
            person.name = newName
            self?.collectionView.reloadData()
            
        })
        present(ac1,animated: true)
        } else {
            let ac2 = UIAlertController(title: "Edit", message: nil, preferredStyle: .alert)
            ac2.addTextField()
            ac2.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            ac2.addAction(UIAlertAction(title: "Submit", style: .default) { [weak self, weak ac2]_ in
                guard let newName = ac2?.textFields?[0].text else {return}
                person.name = newName
                self?.collectionView.reloadData()
            })
            ac2.addAction(UIAlertAction(title: "Delete", style: .destructive){ [weak self]_ in
            self?.people.remove(at: indexPath.item)
            self?.collectionView.reloadData()
            
        })
            present(ac2, animated: true)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else {return}
        let imageName = UUID().uuidString
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)
        if let jpegData = image.jpegData(compressionQuality: 1){
            try? jpegData.write(to: imagePath)
        }
        let person = Person(name: "Unknown", image: imageName)
        people.append(person)
        collectionView.reloadData()
        
        dismiss(animated: true)
    }
    
    func getDocumentsDirectory() -> URL{
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
   

}

