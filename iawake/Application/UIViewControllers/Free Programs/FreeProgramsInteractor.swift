
import Foundation

// MARK: - FreeProgramsInteractorProtocol
protocol FreeProgramsInteractorProtocol {
    func viewDidLoad()
    var presenter: FreeProgramsPresentationProtocol? { get set }
}

// MARK: - FreeProgramsInteractor
class FreeProgramsInteractor {
    var presenter: FreeProgramsPresentationProtocol?
    init(presenter: FreeProgramsPresentationProtocol) {
        self.presenter = presenter
    }
    
    private func getFreePrograms() {
        
        APIWorker.getFreePrograms { [weak self] (result) in
            switch result {
            case .success(let programs):
                guard let programs = programs else {
                    self?.presenter?.presentError(errorString: "Something went wrong");return
                }
                self?.populateData(with: programs)
                break
            case .failure(let errorString):
                self?.presenter?.presentError(errorString: errorString)
                break
            }
        }
    }
    
    private func populateData(with programs: [Program]) {

        var rows = [FreeProgramsViewController.FreePrograms.Row]()
        for item in programs {
            rows.append(.init(programCellData: .init(program: item)))
        }
        presenter?.presentProfile(response: .init(section: .init(rows: rows)))
    }
}

// MARK: - FreeProgramsInteractor delegates
extension FreeProgramsInteractor: FreeProgramsInteractorProtocol {
    
    func viewDidLoad() {
        getFreePrograms()
    }
}
