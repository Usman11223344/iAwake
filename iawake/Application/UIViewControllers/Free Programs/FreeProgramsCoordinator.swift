
import Foundation
import UIKit

// MARK: - FreePrograms Router Protocol
protocol FreeProgramsRouter: AnyObject {
    func start()
    func showTracks(vc: UIViewController, withTracks tracks: [Track]?)
}

// MARK: - FreeProgramsCoordinator Class
class FreeProgramsCoordinator {
    private var window: UIWindow
    private var navigationController: UINavigationController?
    
    init(window: UIWindow) {
        self.window = window
    }
}

// MARK: - Routing
extension FreeProgramsCoordinator: FreeProgramsRouter {
    
    func start() {
        let viewController = FreeProgramsViewController.initiateFrom(Storybaord: .main)
        viewController.interactor = FreeProgramsInteractor(presenter: FreeProgramsPresenter(viewController: viewController))
        viewController.router = self
        self.window.rootViewController = UINavigationController(rootViewController: viewController)
    }
    
    func showTracks(vc: UIViewController, withTracks tracks: [Track]?) {
        let tracksCoordinator = TracksCoordinator()
        tracksCoordinator.start(from: vc, withTracks: tracks ?? [])
    }
    
}
