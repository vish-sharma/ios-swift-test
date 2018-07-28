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
    
    @IBOutlet weak var noteTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        noteTextView.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        noteTextView.resignFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

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

        self.navigationController?.popViewController(animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
