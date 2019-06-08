//
//  ViewController.swift
//  MilestoneProject4
//
//  Created by Donny G on 07/06/2019.
//  Copyright © 2019 Donny G. All rights reserved.
//

import UIKit

class ViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var objects = [CapturedObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(takePicture))
        tableView.backgroundView = UIImageView(image: UIImage(named: "IMG_3295.JPG"))
        load()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = objects[indexPath.row].objectName
        cell.backgroundColor = .black
        cell.textLabel?.textColor = .cyan
        cell.textLabel?.font = UIFont.systemFont(ofSize: 30)
        return cell
    }
    
    @objc func takePicture(){
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            picker.sourceType = .camera
        }else{
            picker.sourceType = .photoLibrary
        }
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else {return}
        let fileName = UUID().uuidString
        let path = getDocumentsDir().appendingPathComponent(fileName)
        if let jpegData = image.jpegData(compressionQuality: 1){
           try? jpegData.write(to: path)
        }
        
        dismiss(animated: true) {
            [weak self] in
            let ac = UIAlertController(title: "Name", message: nil, preferredStyle: .alert)
            ac.addTextField(configurationHandler: { (textField) in
                textField.placeholder = "Enter name"
                textField.font = UIFont.systemFont(ofSize: 24)
            })
            ac.addAction(UIAlertAction(title: "Cancel", style: .destructive))
            ac.addAction(UIAlertAction(title: "Save", style: .default, handler: { [weak ac, weak self] _ in
                guard let objectName = ac?.textFields?[0].text else {return}
                let person = CapturedObject(objectName: objectName, fileName: fileName)
                self?.objects.append(person)
                self?.tableView.reloadData()
                self?.save()
            }))
            self?.present(ac, animated: true)
        }
    }
    
    func getDocumentsDir() -> URL{
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController else { fatalError("Error")}
        vc.object = objects[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func save(){
        let jsonEncoder = JSONEncoder()
        do{
            let objectsData = try jsonEncoder.encode(objects)
            UserDefaults.standard.set(objectsData, forKey: "objectsData")
        }catch{
            print("Unable to save data")
        }
    }
    
    func load(){
        guard let objectsData = UserDefaults.standard.object(forKey: "objectsData") as? Data else { print("No data stored")
            return
        }
        let jsonDecoder = JSONDecoder()
        do {
            objects = try jsonDecoder.decode([CapturedObject].self, from: objectsData)
        } catch {
            print("Unable to load data")
        }
    }
    
}

