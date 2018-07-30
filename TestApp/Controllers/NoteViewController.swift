//
//  ViewController.swift
//  TestApp
//
//

import UIKit

class NoteViewController: UIViewController {

    let viewModel = NotesViewModel()
    var notesDataSource: NotesDataSource?
    @IBOutlet weak var noteTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        selectNotesDataSoruce { [weak self] (dataSource) in
            //ViewModel - Invoke API Call to fetch Data from Mock Json file.
            if dataSource == NotesDataSource.MockJson {//!useCoreData
                self?.viewModel.invokeApiCall(noteDataSource: dataSource!, completion: { (success, error) in
                    if success {
                        //Reload table
                    }
                })
            } else {
                self?.viewModel.fetchNotesFromStore(noteDataSource: dataSource!)
                //Reload table
            }
            
            DispatchQueue.main.async {
                self?.noteTableView.reloadData()
            }
        }
        
        //Register cell Xib with View Controller
        noteTableView.register(UINib(nibName:"NoteTableViewCell",bundle:nil),
                                    forCellReuseIdentifier: "NoteCell")
        noteTableView.tableFooterView = UIView()
        
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if notesDataSource == NotesDataSource.CoreData {
            viewModel.fetchNotesFromStore(noteDataSource: notesDataSource!)
        }
        noteTableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func selectNotesDataSoruce (completion:@escaping (NotesDataSource?) -> Void) {
        let alert = UIAlertController(title: "Load Notes Data", message: "Fetch Notes based upon User preference", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Core Data", style: .default, handler:{ [weak self] action in
            print("Load Core data!")
            self?.notesDataSource = NotesDataSource.CoreData
            completion(self?.notesDataSource)
        }))
        alert.addAction(UIAlertAction(title: "Mock Response", style: .default, handler: { [weak self] action in
            print("Load Mock response!")
            self?.notesDataSource = NotesDataSource.MockJson
            completion(self?.notesDataSource)
        }))
        
        self.present(alert, animated: true)
        
    }
    
    
    // MARK: - Navigation
    
    @IBAction func addNoteTapped(_ sender: Any) {
        self.performSegue (withIdentifier:AppConstants.StoryBoard.AddNoteSegue, sender: self)
    }
    
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
        
        if notesDataSource == NotesDataSource.CoreData {
            //Core Data
            if let note = viewModel.getNoteDataForIndex(indexPath.row) {
                cell.messageLabel.text = note.message
                cell.dateLabel.text = note.date
            }
        } else {
            //Mock JSON
            if let note = viewModel.getNoteForIndex(indexPath.row) {
                cell.messageLabel.text = note.message
                cell.dateLabel.text = note.date
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            print("Deleted")
            viewModel.deleteNote(atIndex: indexPath.row)
            
            noteTableView.beginUpdates()
            noteTableView.deleteRows(at: [indexPath], with: .automatic)
            noteTableView.endUpdates()
        }
    }
}

extension NoteViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if notesDataSource == NotesDataSource.MockJson {
            viewModel.filterNotesArray(inputStr: searchText)
        } else {
            viewModel.filterNotesDataArray(inputStr: searchText)
        }
        
        noteTableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        
    }
}

