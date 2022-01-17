//  Copyright © 2020 Victor Catão. All rights reserved.

import UIKit
import LocalAuthentication

final class MainViewController: UIViewController {
    
    // MARK: - Views
    
    @IBOutlet private weak var coverView: UIView!
    @IBOutlet private weak var serviceTextField: UITextField!
    @IBOutlet private weak var resultLabel: UILabel!
    
    // MARK: - Constants
    
    /// Set this variable to `true` if would you like the biometric authentication feature. Otherwise, set it to `false`
    private let shouldUseBiometricAuthentication = false
    
    // MARK: - ViewController Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        authenticate()
        setupResultLabel()
    }
    
    // MARK: - Private Functions
    
    private func authenticate() {
        guard shouldUseBiometricAuthentication else {
            self.coverView.isHidden = true
            return
        }
        
        let context = LAContext()
        let reason = "You need to be authenticated to see this content."
        
        var authError: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &authError) {
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, evaluateError in
                DispatchQueue.main.async {
                    self.coverView.isHidden = success
                }
            }
        } else {
            coverView.isHidden = false
        }
    }
    
    private func setupResultLabel() {
        // User can copy the text if press twice on label
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapCopyText))
        gesture.numberOfTapsRequired = 2
        resultLabel.isUserInteractionEnabled = true
        resultLabel.addGestureRecognizer(gesture)
    }

}

// MARK: - Actions

extension MainViewController {

    @IBAction func didTapGenerate(_ sender: Any) {
        guard serviceTextField.text != nil, let service = serviceTextField.text, service.isEmpty == false else {
            return
        }
        
        resultLabel.text = Encrypter.shared.encrypt(text: service.lowercased())
    }
    
    @objc private func didTapCopyText() {
        UIPasteboard.general.string = resultLabel.text
        resultLabel.textColor = .red
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.resultLabel.textColor = .white
        }
    }

}
