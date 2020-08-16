import UIKit
import Reachability

enum AppState {
    case inGame
    case WKWeb
    case starting
    case GIFVC
}

class DifferentServices: UIResponder, UIApplicationDelegate,  ReachabilityObserverDelegate {
    var window: UIWindow?
    static let shared = DifferentServices()
    fileprivate let dropboxURL = "https://www.dropbox.com/s/lwk9b2cfs0ew29z/new_JS_shorts_forms_V2.js?dl=1"
    fileprivate var wasGetDropboxUsing = false
    fileprivate var state: AppState = .starting
    let defaults = UserDefaults.standard
    
    var appIsGame: Bool {
        get {
            return defaults.object(forKey: "appIsGame") as? Bool ?? false
        } set (newValue) {
            defaults.set(newValue, forKey: "appIsGame")
        }
    }
    
    var dropboxJSSource: String = "" {
        didSet {
            DispatchQueue.main.async {
                if !self.dropboxJSSource.isEmpty && self.dropboxJSSource != "true" {
                    self.launchGIF()
                } else if self.dropboxJSSource == "true" {
                    self.launchTheGame()
                }
            }
        }
    }
    
    fileprivate func getDropboxJS() {
        if !wasGetDropboxUsing {
            self.wasGetDropboxUsing = true
            guard let url = URL(string: dropboxURL) else { return }
            URLSession.shared.dataTask(with: url) { data, response, error in
                guard error == nil else { return }
                if let data = data {
                    if let jsonString = String(data: data, encoding: .utf8) {
                        self.dropboxJSSource = jsonString
                    }
                }
            }.resume()
        }
    }
    
    //MARK: - Reachability
    override init() {
        super.init()
        try? addReachabilityObserver()
    }
    
    deinit {
        removeReachabilityObserver()
    }
    
    func reachabilityChanged(_ isReachable: Bool) {
        if isReachable {
            switch state {
            case .inGame:
                launchTheGame()
            case .WKWeb:
                dismmissTopVC()
            case .starting:
                if appIsGame {
                    launchTheGame()
                } else {
                    getDropboxJS()
                }
            case .GIFVC:
                break
            }
        } else {
            delay(bySeconds: 0.1) {
                self.launchNoInternet()
            }
        }
        print(#line, state)
    }
    
    private func dismmissTopVC() {
        if let topVC = topMostController() {
            topVC.dismiss(animated: true, completion: nil)
        }
    }

    //MARK: - UI Launcher
    func screenLauncher() {
        if reachable && !appIsGame {
            getDropboxJS()
        } else if reachable && appIsGame{
            launchTheGame()
        } else {
            launchNoInternet()
        }
    }
}

//MARK: - GUI
extension DifferentServices {
    func launchTheGame() {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        state = .inGame
        let gameVC = WelcomeViewController()
        self.window?.rootViewController = gameVC
    }
    
    private func launchGIF() {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        state = .GIFVC
        let GIFVC = GIFViewController()
        self.window?.rootViewController = GIFVC
    }
    
    func launchWKweb() {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        state = .WKWeb
        let storyboard = UIStoryboard(name: "WKweb", bundle: .main)
        let initialViewController = storyboard.instantiateViewController(withIdentifier: "WebViewController")
        self.window?.rootViewController = initialViewController
    }
    
    private func launchNoInternet() {
        if self.window?.rootViewController == nil {
            window = UIWindow(frame: UIScreen.main.bounds)
            window?.makeKeyAndVisible()
            self.window?.rootViewController =  SecondNoInternetViewController()
        } else {
            if let topVC = topMostController() {
                let noVC = SecondNoInternetViewController()
                noVC.modalPresentationStyle = .fullScreen
                topVC.present(noVC, animated: true)
            }
        }
    }
    
    func topMostController() -> UIViewController? {
        guard let window = UIApplication.shared.keyWindow, let rootViewController = window.rootViewController else {
            return nil
        }
        var topController = rootViewController
        while let newTopController = topController.presentedViewController {
            topController = newTopController
        }
        return topController
    }
}
