
import Foundation

// MARK: - Presentation Protocol
protocol FreeProgramsPresentationProtocol {
    func presentProfile(response: FreeProgramsViewController.FreePrograms.ViewData)
    func presentError(errorString: String)
}

// MARK: - Presenter Class
class FreeProgramsPresenter {
    weak var viewController: FreeProgramsDisplayLogic?
    
    init(viewController: FreeProgramsDisplayLogic) {
        self.viewController = viewController
    }
}

// MARK: - Presenter Delegates
extension FreeProgramsPresenter: FreeProgramsPresentationProtocol {
    
    func presentProfile(response: FreeProgramsViewController.FreePrograms.ViewData) {
        viewController?.displayUserProfile(viewData: response)
    }
    
    func presentError(errorString: String) {
        viewController?.displayError(errorString: errorString)
        
    }
}
