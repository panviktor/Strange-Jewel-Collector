import UIKit

class WelcomeViewController: UIViewController {
    private let screenSize: CGRect = UIScreen.main.bounds
    
    private let rootView: UIImageView = {
        let view = UIImageView(image: UIImage(named: ImageName.welcomeViewBackground))
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let itemElementImage: UIImageView = {
        let view = UIImageView(image: UIImage(named: ImageName.welcomeItemElement))
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    private let playButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: ImageName.welcomePlayButton), for: .normal)
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadGUI()
        itemElementImage.pulsate(5)
        playButton.pulsate(5)
    }
    
    private func loadGUI() {
        view.addSubview(rootView)
        rootView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        rootView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        rootView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        rootView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        
        view.addSubview(itemElementImage)
        itemElementImage.topAnchor.constraint(equalTo: view.topAnchor, constant: -10).isActive = true
        itemElementImage.widthAnchor.constraint(equalToConstant: 425).isActive = true
        itemElementImage.heightAnchor.constraint(equalToConstant: 425).isActive = true
        itemElementImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(playButton)
        playButton.widthAnchor.constraint(equalToConstant: screenSize.size.width * 0.80).isActive = true
        playButton.heightAnchor.constraint(equalToConstant: 350).isActive = true
        playButton.topAnchor.constraint(equalTo: view.centerYAnchor, constant: -25).isActive = true
        playButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @objc private func buttonAction() {
        launchTheGame()
    }
    
    private func launchTheGame() {
        let GameVC = GameViewController()
        GameVC.modalPresentationStyle = .fullScreen
        self.present(GameVC, animated: true)
    }
}

