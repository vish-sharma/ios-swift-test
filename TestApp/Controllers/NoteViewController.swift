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
    
    var selectedNote: Note?
    var selectedIndex: Int?
    
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
        noteTableView.register(UINib(nibName:AppConstants.StoryBoard.NoteTableViewCell,bundle:nil),
                                    forCellReuseIdentifier: AppConstants.StoryBoard.NoteCell)
        noteTableView.tableFooterView = UIView()
        
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if notesDataSource == NotesDataSource.CoreData {
            viewModel.fetchNotesFromStore(noteDataSource: notesDataSource!)
        }
        noteTableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if selectedNote != nil {
            selectedNote = nil
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    /*
     * Method to Display Alert Controller and handle the user selection
     */
    private func selectNotesDataSoruce (completion:@escaping (NotesDataSource?) -> Void) {
        let alert = UIAlertController(title: AppConstants.UIText.AlertTitle, message: AppConstants.UIText.AlertMessage, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: AppConstants.UIText.AlertCoreButton, style: .default, handler:{ [weak self] action in
            self?.notesDataSource = NotesDataSource.CoreData
            completion(self?.notesDataSource)
        }))
        alert.addAction(UIAlertAction(title: AppConstants.UIText.AlertMockButton, style: .default, handler: { [weak self] action in
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
                if selectedNote != nil {
                    destinationVC.existingNote = selectedNote
                    destinationVC.existingNoteIndex = selectedIndex
                }
            }
        }
    }
}

extension NoteViewController: UITableViewDataSource, UITableViewDelegate {
    
    /*
     * Method to return Number of rows for Table view
     */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows()
    }
    
    /*
     * Method to display Cells based upon DataSource
     */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: AppConstants.StoryBoard.NoteCell, for: indexPath) as! NoteTableViewCell
        
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
    
    /*
     * Method to handle Cell Deletion
     */
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            viewModel.deleteNote(atIndex: indexPath.row)
            
            noteTableView.beginUpdates()
            noteTableView.deleteRows(at: [indexPath], with: .automatic)
            noteTableView.endUpdates()
        }
    }
    
    /*
     * Method to handle Cell selection based on DataSource
     */
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if notesDataSource == NotesDataSource.CoreData {
            //Core Data
            if let note = viewModel.getNoteDataForIndex(indexPath.row) {
                selectedNote = note
            }
        } else {
            //Mock JSON
            if let note = viewModel.getNoteForIndex(indexPath.row) {
                selectedNote = note
            }
        }
        selectedIndex = indexPath.row
        self.performSegue (withIdentifier:AppConstants.StoryBoard.AddNoteSegue, sender: self)
    }
}

extension NoteViewController: UISearchBarDelegate {
    
    /*
     * Method to handle Search bar and filter DataSources based on user's entry
     */
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if notesDataSource == NotesDataSource.MockJson {
            viewModel.filterNotesArray(inputStr: searchText)
        } else {
            viewModel.filterNotesDataArray(inputStr: searchText)
        }
        
        noteTableView.reloadData()
    }
}

