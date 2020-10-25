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
    
    // Instantiate cocoaMQTT as mqttClient
    let mqttClient = CocoaMQTT(clientID: "iOS Device", host: "<RASP PI Network Address>", port: 1883)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeVideoPlayerWithVideo(viewName: "Spectro")
        player?.play()
        self.loopVideo(videoPlayer: player!)
        mqttClient.publish("duration", withString: String(measurementDuration))
    }
    
    
    @IBAction func startButtonTapped(_ sender: CustomButton) {
        startButton.shake()
        // Tell Pi to start measurement ("operation" is the topic)
        mqttClient.publish("operation", withString: "start")
    }
    
    @IBAction func stopButtonTapped(_ sender: CustomButton) {
        stopButton.shake()
        // Tell Pi to stop measurement ("operation" is the topic)
        mqttClient.publish("operation", withString: "stop")
    }
    
    @IBAction func connectButtonTapped(_ sender: CustomButton) {
        connectButton.shake()
        mqttClient.connect()
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
        self.performSegue(withIdentifier: "ResultsSegue", sender: self)
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
