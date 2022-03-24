
import Foundation

// MARK: - Presentation Protocol
protocol TracksPresentationProtocol {
    func presentTracks(response: [Track])
    func presentError(errorString: String)
}

// MARK: - Presenter Class
class TracksPresenter {
    weak var viewController: TracksDisplayLogic?
    
    init(viewController: TracksDisplayLogic) {
        self.viewController = viewController
    }
}

// MARK: - Presenter Delegates
extension TracksPresenter: TracksPresentationProtocol {
    
    func presentTracks(response: [Track]) {
        
        var rows: [TracksViewController.ProgramTracks.Row] = []
        
        for track in response {
            rows.append(.init(trackCellData: .init(track: track)))
        }
        viewController?.displayTracks(viewData: .init(section: .init(rows: rows)))
    }
    
    func presentError(errorString: String) {
        viewController?.displayError(errorString: errorString)
    }
}
