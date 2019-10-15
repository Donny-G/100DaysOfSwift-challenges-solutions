//
//  ViewController.swift
//  Milestone project 7 (notes)
//
//  Created by Donny G on 27/09/2019.
//  Copyright © 2019 Donny G. All rights reserved.
//

import UIKit

class ViewController: UITableViewController, TransferDataProtocol  {
   
    var notes = [Note]()
    var selectedNote: Note?
    var newNote: Note?
    
    var newNoteId: String?
    var selectedNoteId: String?
    
    //update table view after returning from DVC
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
        load()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let newNoteButton = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(new))
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        toolbarItems = [spacer, newNoteButton]
        navigationController?.isToolbarHidden = false
        //make color of elements like original Notes app
        navigationController?.navigationBar.tintColor = .systemOrange
        navigationController?.toolbar.tintColor = .systemOrange
        tableView.separatorColor = .systemOrange
        self.tableView.backgroundColor = UIColor.init(red: 0.977, green: 1.000, blue: 0.812, alpha: 1.00)

    }
    
    //after checking what type of note we deal with in DVC, we will save new note in our array, or update existing note
    func transfer(data: Note) {
        if selectedNoteId == data.id {
            if let index = notes.firstIndex(where: { $0.id == data.id}) {
            notes[index].text = data.text }
            save()
        } else {
            self.newNote = data
            self.notes.append(newNote ?? Note(id: "", text: "", date: Date()))
            save()
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Notecell", for: indexPath)
        cell.textLabel?.text = notes[indexPath.row].text
        cell.detailTextLabel?.text = Note.getCurrentDate()
        cell.backgroundColor = UIColor.init(red: 0.977, green: 1.000, blue: 0.812, alpha: 1.00)
        return cell
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let detailVC = segue.destination as? DetailViewController else {return}
        detailVC.delegate = self
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedNoteId = notes[indexPath.row].id
        if let vc = storyboard?.instantiateViewController(withIdentifier: "DVC") as? DetailViewController {
            vc.selectedNote = notes[indexPath.row]
            vc.selectedNoteId = notes[indexPath.row].id
            vc.delegate = self
            vc.delegate2 = self
            navigationController?.pushViewController(vc, animated: true)
            }
    }
    
    @objc func new(){
        let newNote = Note(id: UUID().uuidString, text: "", date: Date())
        newNoteId = newNote.id
        if let vc = storyboard?.instantiateViewController(withIdentifier: "DVC") as? DetailViewController {
            vc.newNote = newNote
            vc.newNoteId = newNote.id
            vc.delegate = self
            navigationController?.pushViewController(vc, animated: true)
            }
    }
    
    func save(){
       let encoder = JSONEncoder()
       if let dataToSave = try? encoder.encode(notes) {
           UserDefaults.standard.set(dataToSave, forKey: "savedNotes")
       } else {
           print("Unable to save")
       }
    }
    
    func load(){
        if let dataToLoad = UserDefaults.standard.object(forKey: "savedNotes") as? Data {
        let decoder = JSONDecoder()
                   do {
                       notes = try decoder.decode([Note].self, from: dataToLoad)
                   } catch {
                       print("Unable to load")
                   }
           }
    }

    func deleteData(id: String) {
        if let note = notes.enumerated().first(where:{ $0.element.id == id}) {
            print(note)
            notes.remove(at: note.offset)
        }
        save()
    }
    
}
