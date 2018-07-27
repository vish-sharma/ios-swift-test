//
//  ViewController.swift
//  TestApp
//
//

import UIKit

class NoteViewController: UIViewController {

    let viewModel = NotesViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //ViewModel - Invoke API Call to fetch Data from Mock Json file.
        viewModel.invokeApiCall { (success, error) in
            if success {
                //Reload table
            }
        }
        
        //Testing Date extension
        let myDate = Date()
        let dateStr = myDate.asString(style: .medium)
        print(dateStr)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

