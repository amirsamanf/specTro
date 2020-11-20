//
//  ResultsViewController.swift
//  specTro
//
//  Created by Amirsaman Fazelipour on 2020-10-24.
//
import UIKit
import AVFoundation
import CocoaMQTT


class HomeViewController: UIViewController {
    
    var player: AVPlayer?
    
    @IBOutlet weak var videoViewContainer: UIView!
    @IBOutlet private var startButton: CustomButton!
    @IBOutlet private var stopButton: CustomButton!
    @IBOutlet private var connectButton: CustomButton!
    @IBOutlet private var settingsButton: CustomButton!
    @IBOutlet private var faqButton: CustomButton!
    @IBOutlet private var resultsButton: CustomButton!
    @IBOutlet private var mapButton: CustomButton!
    
    var connected : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeVideoPlayerWithVideo(viewName: "Spectro")
        player?.play()
        self.loopVideo(videoPlayer: player!)
    }
    
    
    @IBAction func startButtonTapped(_ sender: CustomButton) {
        startButton.shake()
        // Tell Pi to start measurement ("operation" is the topic)
//        mqttClient.publish("operation", withString: "start")
        MQTTManager.shared.sendMessage(topic:"operation", message:"start")
    }
    
    @IBAction func stopButtonTapped(_ sender: CustomButton) {
        stopButton.shake()
        // Tell Pi to stop measurement ("operation" is the topic)
//        mqttClient.publish("operation", withString: "stop")
        MQTTManager.shared.sendMessage(topic:"operation", message:"stop")
    }
    
    @IBAction func connectButtonTapped(_ sender: CustomButton) {
        connectButton.shake()

        if self.connected == true {
            connectButton.setTitle("Connect", for: .normal)
//            mqttClient.disconnect()
            MQTTManager.shared.disconnect()
            self.connected = false
        }
        else {
            MQTTManager.shared.connect()
            connectButton.setTitle("Disconnect", for: .normal)
            self.connected = true
        }
    }
    
    @IBAction func settingsButtonTapped(_ sender: CustomButton) {
        settingsButton.shake()
        self.performSegue(withIdentifier: "SettingsSegue", sender: self)
    }
    
    
    @IBAction func faqButtonTapped(_ sender: CustomButton) {
        faqButton.shake()
    }
    
    @IBAction func resultsButtonTapped(_ sender: CustomButton) {
        resultsButton.shake()
//        self.performSegue(withIdentifier: "ResultsSegue", sender: self)
    }
    
    
    @IBAction func mapButtonTapped(_ sender: CustomButton) {
        mapButton.shake()
        self.performSegue(withIdentifier: "MapSegue", sender: self)
    }
    
    
    func loopVideo(videoPlayer: AVPlayer) {
        NotificationCenter.default.addObserver(forName: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil, queue: nil) { notification in
            videoPlayer.seek(to: CMTime.zero)
            videoPlayer.play()
        }
    }
    
    func initializeVideoPlayerWithVideo(viewName: String) {
    
        // get the path string for the video from assets
        let videoString:String? = Bundle.main.path(forResource: viewName, ofType: "mp4")
        
        guard let unwrappedVideoPath = videoString else {return}

        // convert the path string to a url
        let videoUrl = URL(fileURLWithPath: unwrappedVideoPath)

        // initialize the video player with the url
        self.player = AVPlayer(url: videoUrl)
        
        // create a video layer for the player
        let layer: AVPlayerLayer = AVPlayerLayer(player: player)
        

        // make the layer the same size as the container view
        layer.frame = videoViewContainer.bounds
        
        // make the video fill the layer as much as possible while keeping its aspect size
        layer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        
        // add the layer to the container view
        videoViewContainer.layer.addSublayer(layer)
    }
    
}
//
//// Instantiate cocoaMQTT as mqttClient
//let mqttClient = CocoaMQTT(clientID: "iOS Device", host: "192.168.4.1", port: 1883)



class MQTTManager: CocoaMQTTDelegate {
    func mqtt(_ mqtt: CocoaMQTT, didConnectAck ack: CocoaMQTTConnAck) {
        mqttClient.subscribe("setting")
        mqttClient.subscribe("lat")
        mqttClient.subscribe("lon")
        mqttClient.subscribe("dur")
        mqttClient.subscribe("average_0")
        mqttClient.subscribe("average_1")
        mqttClient.subscribe("average_2")
        mqttClient.subscribe("average_3")
        mqttClient.subscribe("average_4")
        mqttClient.subscribe("average_5")
        mqttClient.subscribe("lenPM")
        mqttClient.subscribe("PM1")
        mqttClient.subscribe("PM25")
        mqttClient.subscribe("PM10")
        self.sendMessage(topic: "request", message: "duration")

        MQTTManager.shared.sendMessage(topic: "latitude", message: String(MapViewController.currentCoordinate!.latitude))
        print(MapViewController.currentCoordinate!.latitude)
        MQTTManager.shared.sendMessage(topic: "longitude", message: String(MapViewController.currentCoordinate!.longitude))
        print(MapViewController.currentCoordinate!.longitude)

    }

    func mqtt(_ mqtt: CocoaMQTT, didPublishMessage message: CocoaMQTTMessage, id: UInt16) {
        print("Did publish message \(message)")
    }

    func mqtt(_ mqtt: CocoaMQTT, didPublishAck id: UInt16) {
        print("Did publish Ack \(id)")
    }

    func mqtt(_ mqtt: CocoaMQTT, didReceiveMessage message: CocoaMQTTMessage, id: UInt16) {
        let messageDecoded = String(bytes: message.payload, encoding: .utf8)
        print("Did receive a message: \(messageDecoded!)")
        
        if message.topic == "setting" {
            if messageDecoded != defaults.string(forKey: "duration") {
                self.sendMessage(topic: "duration", message: defaults.string(forKey: "duration") ?? "5.0")
            }
        } else if message.topic == "lat" {
            receivedLat = messageDecoded
        } else if message.topic == "lon" {
            receivedLon = messageDecoded
        } else if message.topic == "dur" {
            receivedDur = messageDecoded
            annotations.append(["title": "Measurement Length: " + String(receivedDur!) + " Minutes", "latitude": Double(receivedLat!), "longitude": Double(receivedLon!)])
        } else if message.topic == "average_0" {
            defaults.set(Int(messageDecoded!), forKey: "a0_" + String(receivedLat!) + String(receivedLon!))
        } else if message.topic == "average_1" {
            defaults.set(Int(messageDecoded!), forKey: "a1_" + String(receivedLat!) + String(receivedLon!))
        } else if message.topic == "average_2" {
            defaults.set(Int(messageDecoded!), forKey: "a2_" + String(receivedLat!) + String(receivedLon!))
        } else if message.topic == "average_3" {
            defaults.set(Int(messageDecoded!), forKey: "a3_" + String(receivedLat!) + String(receivedLon!))
        } else if message.topic == "average_4" {
            defaults.set(Int(messageDecoded!), forKey: "a4_" + String(receivedLat!) + String(receivedLon!))
        } else if message.topic == "average_5" {
            defaults.set(Int(messageDecoded!), forKey: "a5_" + String(receivedLat!) + String(receivedLon!))
        } else if message.topic == "PM1" {
            PM1.append(Int(messageDecoded!)!)
            print("PM1 MESSAGE:")
            print(Int(messageDecoded!)!)
            print("PM1 Size:")
            print(PM1.count)
            if PM1.count == lenPM {
                defaults.set(PM1, forKey: "PM1" + String(receivedLat!) + String(receivedLon!))
                print("ALLLLLLLLL GOOOOOOOOOOOOOOOOD")
                print("ALLLLLLLLL GOOOOOOOOOOOOOOOOD")
                print("ALLLLLLLLL GOOOOOOOOOOOOOOOOD")
                print("ALLLLLLLLL GOOOOOOOOOOOOOOOOD")
                print("ALLLLLLLLL GOOOOOOOOOOOOOOOOD")
            }
        } else if message.topic == "PM25" {
            PM25.append(Int(messageDecoded!)!)
            if PM25.count == lenPM {
                defaults.set(PM25, forKey: "PM25" + String(receivedLat!) + String(receivedLon!))
            }
        } else if message.topic == "PM10" {
            PM10.append(Int(messageDecoded!)!)
            if PM10.count == lenPM {
                defaults.set(PM10, forKey: "PM10" + String(receivedLat!) + String(receivedLon!))
            }
        } else if message.topic == "lenPM" {
            lenPM = Int(messageDecoded!)!
            print("LEN PM:")
            print(lenPM)
        }
        
    }

    func mqtt(_ mqtt: CocoaMQTT, didSubscribeTopic topics: [String]) {
        print("Did subscribe to \(topics)")
    }

    func mqtt(_ mqtt: CocoaMQTT, didUnsubscribeTopic topic: String) {
        print("Did unsubscribe topic \(topic)")
    }

    func mqttDidPing(_ mqtt: CocoaMQTT) {
        print("Did ping")
    }

    func mqttDidReceivePong(_ mqtt: CocoaMQTT) {
        print("Did receive pong")
    }

    func mqttDidDisconnect(_ mqtt: CocoaMQTT, withError err: Error?) {
        print("Did disconnect with error \(String(describing: err))")
    }
    
    
    static let shared = MQTTManager()

    private var mqttClient: CocoaMQTT

    private init() {
        let clientID = "iOS Device"
        let host = "192.168.4.1"
        let port = UInt16(1883)
        self.mqttClient = CocoaMQTT(clientID: clientID, host: host, port: port)
        self.mqttClient.username = ""
        self.mqttClient.password = ""
        self.mqttClient.delegate = self
    }

    func sendMessage(topic:String, message:String){
        self.mqttClient.publish(topic, withString: message)
    }
    
    func subscribe(topic: String) {
        self.mqttClient.subscribe(topic)
    }
    
    
    func disconnect() {
        self.mqttClient.disconnect()
    }
    
    func connect() {
        self.mqttClient.connect()
    }
}
