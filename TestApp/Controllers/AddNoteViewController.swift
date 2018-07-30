//
//  AddNoteViewController.swift
//  TestApp
//
//  Created by Omm on 7/27/18.
//  Copyright © 2018 AlayaCare. All rights reserved.
//

import UIKit

class AddNoteViewController: UIViewController {

    var viewModel = NotesViewModel()
    
    //Properties to handle Editing of existing notes
    var existingNote: Note?
    var existingNoteIndex: Int?
    
    @IBOutlet weak var noteTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Editing Existing notes
        if existingNote != nil {
            noteTextView.text = existingNote?.message
        }
        
        noteTextView.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        noteTextView.resignFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    /*
     * Method to handle Bar button items
     */
    @IBAction func cancelButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        //Testing Date extension
        let myDate = Date()
        let dateStr = myDate.asString(style: .medium)
        
        //New note is nil
        let newNote: Note = Note(message: noteTextView.text, date: dateStr)
        viewModel.addNewNote(newNote)
        
        if existingNote != nil {
            if let selectedNote = existingNoteIndex {
                viewModel.deleteNote(atIndex: selectedNote)
            }
        }
        self.navigationController?.popViewController(animated: true)
    }
}
