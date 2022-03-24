
import Foundation

// MARK: - TracksInteractorProtocol
protocol TracksInteractorProtocol {
    func viewDidLoad()
    func getTracks()
    var tracks: [Track]? { get }
}

// MARK: - TracksInteractor
class TracksInteractor {
    var presenter: TracksPresentationProtocol?
    internal var tracks: [Track]?
    
    init(presenter: TracksPresentationProtocol, tracks: [Track]?) {
        self.presenter = presenter
        self.tracks = tracks
    }
}

// MARK: - TracksInteractor delegates
extension TracksInteractor: TracksInteractorProtocol {
    
    func viewDidLoad() {
        
    }
    
    func getTracks() {
        guard let _tracks = tracks else { presenter?.presentError(errorString: "Tracks not found");return
        }
        presenter?.presentTracks(response: _tracks)
        
    }
}
