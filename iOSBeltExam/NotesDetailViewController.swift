//
//  NotesDetailViewController.swift
//  iOSBeltExam
//
//  Created by Lu Yu on 1/27/17.
//  Copyright © 2017 Lu Yu. All rights reserved.
//

import UIKit
import CoreData

class NotesDetailViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var noteTextView: UITextView!
    var note: Note?
    var newNote: Note?

    override func viewDidLoad() {
        super.viewDidLoad()
        noteTextView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        noteTextView.becomeFirstResponder()
        
        if let n = note {
            noteTextView.text = n.text
        } else {
            newNote = NSEntityDescription.insertNewObject(forEntityName: "Note", into: context) as? Note
            newNote?.updatedAt = Date() as NSDate?
        }
        ad.saveContext()
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let date = Date() as NSDate?
        if let new = newNote {
            new.text = noteTextView.text
            new.updatedAt = date
        } else {
            note?.text = noteTextView.text
            note?.updatedAt = date
        }
        ad.saveContext()
    }
}
