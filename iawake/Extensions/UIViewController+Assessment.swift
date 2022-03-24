
import Foundation
import UIKit
import MBProgressHUD

extension UIViewController {
    class var storyboardID: String {
        return "\(self)"
    }
    
    static func initiateFrom(Storybaord storybaord: Storyboard) -> Self {
        return storybaord.viewController(Class: self)
    }
}

extension UIViewController {
    func showHUD(progressLabel: String = "Loading..."){
        DispatchQueue.main.async{
            let progressHUD = MBProgressHUD.showAdded(to: self.view, animated: true)
            progressHUD.label.text = progressLabel
        }
    }
    
    func dismissHUD(isAnimated:Bool = true) {
        DispatchQueue.main.async{
            MBProgressHUD.hide(for: self.view, animated: isAnimated)
        }
    }
    
    func showToast(message: String) {
        let progressHUD = MBProgressHUD.showAdded(to: self.view, animated: true)
        progressHUD.mode = MBProgressHUDMode.text
        progressHUD.detailsLabel.text = "Your message here"
        progressHUD.margin = 10.0
        progressHUD.offset.y = 150.0
        progressHUD.isUserInteractionEnabled = false
        progressHUD.removeFromSuperViewOnHide = true
        progressHUD.hide(animated: true, afterDelay: 4.0)
    }
}

// MARK: - StoryBoard Configurator
enum Storyboard: String {
    case main = "Main" ///we can add more cases if working in bigger teams and more storyboard files are created
    var instance: UIStoryboard {
        return UIStoryboard(name: self.rawValue, bundle: Bundle.main)
    }

    func viewController<T: UIViewController>(Class viewControllerClass: T.Type) -> T {
        let  storboardID = (viewControllerClass as UIViewController.Type).storyboardID
        return self.instance.instantiateViewController(withIdentifier: storboardID) as! T
    }
}
