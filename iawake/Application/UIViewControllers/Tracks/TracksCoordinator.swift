
import Foundation
import UIKit

// MARK: - Tracks Router Protocol
protocol TracksRouter: AnyObject {
    func start(from source: UIViewController, withTracks tracks: [Track])
}

// MARK: - TracksCoordinator Class
class TracksCoordinator {
    
}

// MARK: - Routing
extension TracksCoordinator: TracksRouter {
    
    func start(from source: UIViewController, withTracks tracks: [Track]) {
        let viewController = TracksViewController.initiateFrom(Storybaord: .main)
        viewController.interactor = TracksInteractor(presenter: TracksPresenter(viewController: viewController), tracks: tracks)
        viewController.router = self
        
        let navController = UINavigationController(rootViewController: viewController)
        source.present(navController, animated: true) {
            
        }
//        source.navigationController?.pushViewController(viewController, animated: true)
    }
}

