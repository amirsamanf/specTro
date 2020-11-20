//
//  ResultsViewController.swift
//  specTro
//
//  Created by Amirsaman Fazelipour on 2020-10-24.
//
import UIKit

let defaults = UserDefaults.standard
var measurementDuration: Float = 5.0


// Overloading string function
extension String {
    var isNumber : Bool {
        return Double(self) != nil
    }
}

class SettingsViewController: HomeViewController, UITextFieldDelegate {
        
    @IBOutlet var ClearButton: CustomButton!
    @IBOutlet private var DoneButton: CustomButton!
    @IBOutlet var textField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textField.delegate = self
        if defaults.string(forKey: "duration") == "0.0" {
            textField.text = "5.0"
        }
        else {
            textField.text = defaults.string(forKey: "duration")
        }
        
        initializeVideoPlayerWithVideo(viewName: "Settings")
        player?.play()
    }
    
    @IBAction func DoneButtonTapped(_ sender: CustomButton) {
        DoneButton.shake()
        
        if ((textField.text?.isEmpty) == true) {
//            textField.text = "5"
            self.dismiss(animated: true, completion: {self.presentingViewController?.dismiss(animated: true, completion: nil)})

        }
        else if (((textField.text)?.isNumber) == true) && (Float(textField.text!)! >= 0.1) {
            let dur = Float(textField.text!)!
            measurementDuration = dur
            self.dismiss(animated: true, completion: {self.presentingViewController?.dismiss(animated: true, completion: nil)})
            // Tell Pi to update duration ("duration" is the topic)
//            self.sendMessage(topic: "duration", message: textField.text!)
            MQTTManager.shared.sendMessage(topic: "duration", message: textField.text!)
            defaults.setValue(measurementDuration, forKey: "duration")

        }
        else {
            let alert = UIAlertController(title: "Invalid duration", message: "Please enter a number greater than or equal to 0.1", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        
    }
    
    
    @IBAction func ClearButtonTapped(_ sender: CustomButton) {
        ClearButton.shake()
        defaults.removeObject(forKey: "annotations")
    }
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
