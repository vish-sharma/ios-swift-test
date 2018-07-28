//
//  ViewController.swift
//  TestApp
//
//

import UIKit

class NoteViewController: UIViewController {

    let viewModel = NotesViewModel()
    @IBOutlet weak var noteTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Register cell Xib with View Controller
        noteTableView.register(UINib(nibName:"NoteTableViewCell",bundle:nil),
                                    forCellReuseIdentifier: "NoteCell")
        noteTableView.tableFooterView = UIView()
        
        //ViewModel - Invoke API Call to fetch Data from Mock Json file.
        viewModel.invokeApiCall { (success, error) in
            if success {
                //Reload table
                DispatchQueue.main.async {
                    self.noteTableView.reloadData()
                }
            }
        }
        
        //Testing Date extension
//        let myDate = Date()
//        let dateStr = myDate.asString(style: .medium)
//        print(dateStr)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func addNoteTapped(_ sender: Any) {
        print("Add Note")
    }
}

extension NoteViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "NoteCell", for: indexPath) as! NoteTableViewCell
        
        if let note = viewModel.getNoteForIndex(indexPath.row) {
            cell.messageLabel.text = note.message
            cell.dateLabel.text = note.date
        }

        return cell
    }
}

