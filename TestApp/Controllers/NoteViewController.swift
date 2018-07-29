//
//  ViewController.swift
//  TestApp
//
//

import UIKit

class NoteViewController: UIViewController {

    let viewModel = NotesViewModel()
    @IBOutlet weak var noteTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
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
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.noteTableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func addNoteTapped(_ sender: Any) {
        self.performSegue (withIdentifier:AppConstants.StoryBoard.AddNoteSegue, sender: self)
    }
    
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == AppConstants.StoryBoard.AddNoteSegue) {
            if let destinationVC = segue.destination as? AddNoteViewController  {
                //Pass ViewModel Instance
                destinationVC.viewModel = viewModel
            }
        }
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

extension NoteViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.filterNotesArray(inputStr: searchText)
        noteTableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        
    }
}

