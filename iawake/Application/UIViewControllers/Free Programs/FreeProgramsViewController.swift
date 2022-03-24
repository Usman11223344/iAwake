
import UIKit

// MARK: - Master Display Protocol
protocol FreeProgramsDisplayLogic: AnyObject {
    func displayUserProfile(viewData: FreeProgramsViewController.FreePrograms.ViewData)
    func displayError(errorString: String)
}

// MARK: - FreeProgramsViewController
class FreeProgramsViewController: UIViewController {

    // MARK: - Properties
    var interactor: FreeProgramsInteractorProtocol?
    weak var router: FreeProgramsRouter?
    var viewData: FreePrograms.ViewData?
    
    // MARK: - Models
    enum FreePrograms {
        
        struct ViewData {
            let section: Section
        }
        
        struct Section {
                        
            let rows: [Row]
            
            var count: Int {
                return rows.count
            }
            
            subscript(_ index: Int) -> Row {
                return rows[index]
            }
        }
        
        struct Row {
            let programCellData: FreeProgramTableViewCell.ViewData
        }

    }
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            let nib = UINib.init(nibName: "FreeProgramTableViewCell", bundle: nil)
            tableView.register(nib, forCellReuseIdentifier: FreeProgramTableViewCell.identifier)
        }
    }
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        getAllFreePrograms()
    }
    
    // MARK: - Helping Methods
    
    private func set(viewData: FreePrograms.ViewData) {
        self.viewData = viewData
    }
    
    private func getAllFreePrograms() {
        self.showHUD()
        interactor?.viewDidLoad()
    }
}

// MARK: - UserProfileDisplayLogic
extension FreeProgramsViewController: FreeProgramsDisplayLogic {

    func displayUserProfile(viewData: FreeProgramsViewController.FreePrograms.ViewData) {
        self.set(viewData: viewData)
        DispatchQueue.main.async {
            self.dismissHUD()
            self.tableView.reloadData()
        }
    }
    
    func displayError(errorString: String) {
        DispatchQueue.main.async {
            self.dismissHUD()
            self.showToast(message: errorString)
        }
    }

}

// MARK: - UITableViewDelegate
extension FreeProgramsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let _viewData = viewData, indexPath.row < _viewData.section.rows.count  else { return }
        let section = _viewData.section
        let row = section.rows[indexPath.row]
        let program = row.programCellData.program
        router?.showTracks(vc: self, withTracks: program.tracks)
    }
}

// MARK: - UITableViewDataSource
extension FreeProgramsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 96
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.viewData?.section.rows.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let _viewData = viewData, indexPath.row < _viewData.section.rows.count  else { return UITableViewCell() }
        
        let section = _viewData.section
        let row = section.rows[indexPath.row]
        
        let cell: FreeProgramTableViewCell = tableView.dequeueReusableCell(withIdentifier: FreeProgramTableViewCell.identifier, for: indexPath) as! FreeProgramTableViewCell
        cell.configure(with: row.programCellData)
        return cell
    }
}
