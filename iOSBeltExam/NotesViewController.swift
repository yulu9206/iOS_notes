//
//  NotesViewController.swift
//  iOSBeltExam
//
//  Created by Lu Yu on 1/27/17.
//  Copyright © 2017 Lu Yu. All rights reserved.
//

import UIKit
import CoreData

class NotesViewController: UIViewController {
    
    @IBOutlet weak var notesSearchBar: UISearchBar!
    @IBOutlet weak var notesTable: UITableView!
    var notes = [Note]()
    var filteredNotes = [Note]()

    override func viewWillAppear(_ animated: Bool) {
        update()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        notesSearchBar.delegate = self
        notesTable.delegate = self
        notesTable.dataSource = self
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "noteDetailSegue" {
            if let dest = segue.destination as? NotesDetailViewController {
                if let n = sender as? Note {
                    dest.note = n
                }
            }
        }
    }
    
    func sortNotes() {
        filteredNotes.sort { $0.updatedAt?.compare($1.updatedAt! as Date) == .orderedDescending }
    }
    
    func update() {
        let req = NSFetchRequest<NSFetchRequestResult>(entityName: "Note")
        do {
            let results = try context.fetch(req)
            notes = results as! [Note]
            filteredNotes = notes
            
            sortNotes()
            
        } catch {
            print("\(error)")
        }
        notesTable.reloadData()
    }

}

extension NotesViewController: UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let note = filteredNotes[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "noteCell", for: indexPath)
        cell.textLabel?.text = note.text
        
        let dateformat = DateFormatter()
        dateformat.dateFormat = "MM-dd-yyyy"

        cell.detailTextLabel?.text = dateformat.string(from: note.updatedAt as! Date)
        cell.detailTextLabel?.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredNotes.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "noteDetailSegue", sender: filteredNotes[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        context.delete(filteredNotes[indexPath.row])
        ad.saveContext()
        update()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredNotes = []
        if searchText == "" {
            update()
        } else {
            for note in notes {
                if (note.text?.lowercased().contains((searchBar.text?.lowercased())!))! {
                    filteredNotes.append(note)
                }
            }
            sortNotes()
            notesTable.reloadData()
        }
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.resignFirstResponder()
    }
    
}
