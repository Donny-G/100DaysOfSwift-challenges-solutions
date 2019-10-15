//
//  DetailViewController.swift
//  Milestone project 7 (notes)
//
//  Created by Donny G on 27/09/2019.
//  Copyright © 2019 Donny G. All rights reserved.
//

import UIKit

//protocol for transfer data to main VC
protocol TransferDataProtocol {
    func transfer(data: Note)
}

class DetailViewController: UIViewController, UITextViewDelegate {
    
    //delegate for protocol
    var delegate: TransferDataProtocol?
    
    //delegate for VC
    var delegate2: ViewController?
    
    var selectedNote: Note?
    var newNote: Note?
    
    var newNoteId: String?
    var selectedNoteId: String?
    
    @IBOutlet var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.delegate = self
        textView.text = selectedNote?.text
        textView.backgroundColor = UIColor.init(red: 0.977, green: 1.000, blue: 0.812, alpha: 1.00)
        view.backgroundColor = UIColor.init(red: 0.977, green: 1.000, blue: 0.812, alpha: 1.00)
        
        let deleteButton = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteNote))
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        toolbarItems = [spacer, deleteButton]
        navigationController?.isToolbarHidden = false
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(sharing))
        
        configureKeyboardObservers()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //check what type of note we deal with before go back by tapping back button
        if self.delegate != nil && self.textView != nil && self.newNoteId != nil {
            let sendData = self.textView.text ?? ""
            delegate?.transfer(data: Note(id: newNoteId, text: sendData, date: Date()))
            dismiss(animated: true, completion: nil)
   
        } else if self.delegate != nil && self.textView != nil && self.selectedNoteId != nil {
            let sendData = self.textView.text ?? ""
            delegate?.transfer(data: Note(id: selectedNoteId, text: sendData, date: Date()))
            dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func deleteNote(){
        delegate2?.deleteData(id: selectedNote?.id ?? "")
         navigationController?.popToRootViewController(animated: true)
    }
    
    @objc func sharing(){
        var sharingData: String?
        //check what type of note we want to share
        if selectedNoteId == nil {
            sharingData = textView.text
        } else {
            sharingData = selectedNote?.text}
        let avc = UIActivityViewController(activityItems: [sharingData ?? ""], applicationActivities: [])
        avc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(avc, animated: true)
    }
    
    func configureKeyboardObservers() {
    
    // To resize the textView when the keyboard shows or hides
    let notificationCenter = NotificationCenter.default
    notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
    notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            textView.contentInset = .zero
        } else {
            textView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }
        
        textView.scrollIndicatorInsets = textView.contentInset
        
        let selectedRange = textView.selectedRange
        textView.scrollRangeToVisible(selectedRange)
    }
    
}



