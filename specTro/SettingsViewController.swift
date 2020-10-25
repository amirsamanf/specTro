//
//  ResultsViewController.swift
//  specTro
//
//  Created by Amirsaman Fazelipour on 2020-10-24.
//
import UIKit

var measurementDuration: Float = 5.0

// Overloading string function
extension String {
    var isNumber : Bool {
        return Double(self) != nil
    }
}

class SettingsViewController: HomeViewController, UITextFieldDelegate {
        
    @IBOutlet private var DoneButton: CustomButton!
    @IBOutlet var textField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textField.delegate = self
        textField.text = String(measurementDuration)
        initializeVideoPlayerWithVideo(viewName: "Settings")
        player?.play()
    }
    
    @IBAction func DoneButtonTapped(_ sender: CustomButton) {
        DoneButton.shake()
        
        if ((textField.text?.isEmpty) == true) {
//            textField.text = "5"
            self.dismiss(animated: true, completion: {self.presentingViewController?.dismiss(animated: true, completion: nil)})

        }
        else if (((textField.text)?.isNumber) == true) && (Float(textField.text!)! > 0.5) {
            let dur = Float(textField.text!)!
            measurementDuration = dur
            self.dismiss(animated: true, completion: {self.presentingViewController?.dismiss(animated: true, completion: nil)})
            // Tell Pi to update duration ("duration" is the topic)
            mqttClient.publish("duration", withString: textField.text!)
        }
        else {
            let alert = UIAlertController(title: "Invalid duration", message: "Please enter a number greater than or equal to 0.5", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
