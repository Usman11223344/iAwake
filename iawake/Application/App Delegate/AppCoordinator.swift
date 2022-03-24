
import Foundation
import UIKit

// MARK: - AppRouter Protocol
protocol AppRouter: AnyObject {
    func start()
}

final class AppCoordinator {
    
    private var window: UIWindow
    private var freeProgramsCoordinator: FreeProgramsCoordinator?
    
    init(window: UIWindow) {
        self.window = window
    }
    
    // MARK: - Private Methods
    private func showFreePrograms() {
        self.freeProgramsCoordinator = FreeProgramsCoordinator.init(window: window)
        self.freeProgramsCoordinator?.start()
    }
}

// MARK: - AppRouter Delegates
extension AppCoordinator: AppRouter {
    
    func start() {
        self.window.backgroundColor = .white
        self.window.overrideUserInterfaceStyle = .light
        self.window.makeKeyAndVisible()
        showFreePrograms()
    }
}
