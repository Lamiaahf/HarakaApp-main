//
//  WorkoutViewController.swift
//  Haraka-AR
//
//  Created by Njood Alhajery on 26/03/2021.
//

import UIKit
import ARKit
import Firebase
import FirebaseAuth

class WorkoutViewController: UIViewController, ARSCNViewDelegate, ARCoachingOverlayViewDelegate {
    

    // UI Variables
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var descriptionView: UIView!
    @IBOutlet weak var swipeView: UIView!
    @IBOutlet weak var sceneView: ARSCNView!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var tapToStartView: UIView!
    @IBOutlet weak var tapToStartInnerView: UIView!
    // Variables
    private let guidanceOverlay = ARCoachingOverlayView()
    var configuration = ARWorldTrackingConfiguration()
    var currentNode: SCNNode?
    var workout: WorkoutModel?
    var index: Int?
    var result: [ARHitTestResult]?
    var startTime: Date?
    var currentGame: Game?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Set delegate
        sceneView.delegate = self
        sceneView.automaticallyUpdatesLighting = true
        sceneView.autoenablesDefaultLighting = true
        sceneView.debugOptions.insert(.showCreases)
        
        if ARWorldTrackingConfiguration.supportsFrameSemantics(.personSegmentationWithDepth) {
            configuration.frameSemantics.insert(.personSegmentation)
        }
    
        setOverlay()
        
        // Set workout
        self.index = 0
        self.workout = WorkoutModel().getWorkoutData()[self.index!]
        result = []
        
        self.swipeView.alpha = 0
        self.descriptionView.alpha = 0
        
        // Add tap gesture
        addTapGestureToSceneView()
        
        // Tap to start inner view
        tapToStartInnerView.setOverlay()
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        configuration.isLightEstimationEnabled = true
        configuration.planeDetection = .horizontal
        sceneView.session.run(configuration)
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause a session
        sceneView.session.pause()
    }
    
    
    func initializeGame(g: Game){
        currentGame = g
    }

    func setOverlay() {
        
        // connect guidanceoverlay with current session
        guidanceOverlay.session = sceneView.session
        guidanceOverlay.delegate = self
        sceneView.addSubview(guidanceOverlay)
        
        // set constraints
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item:  guidanceOverlay, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item:  guidanceOverlay, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0),
            NSLayoutConstraint(item:  guidanceOverlay, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0),
            NSLayoutConstraint(item:  guidanceOverlay, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0)
        ])
        
        guidanceOverlay.translatesAutoresizingMaskIntoConstraints = false
        
        // enable overlay to activate automatically
        guidanceOverlay.activatesAutomatically = true
        
        // set the goal of the overlay to horizontalplane
        guidanceOverlay.goal = .horizontalPlane
    }
    
    
    func addTapGestureToSceneView() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTap(withGestureRecognizer:)))
        tapToStartView.addGestureRecognizer(tapGestureRecognizer)
        
        let pinchGestureRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(didZoom(withGestureRecognizer:)))
        sceneView.addGestureRecognizer(pinchGestureRecognizer)
        
        let swipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(didSwipe(withGestureRecognizer:)))
        sceneView.addGestureRecognizer(swipeGestureRecognizer)
    }
    
    func addWorkoutNode(hitResult: ARHitTestResult) {
        if let workout = workout, let newWorkout = Workout(rawValue: workout.name) {
            let workoutNode = WorkoutNode(hitResult: hitResult, workout: newWorkout.modelName)
            currentNode = workoutNode
            if(sceneView.scene.rootNode.childNodes.isEmpty){
                sceneView.scene.rootNode.addChildNode(currentNode!)
            }
            else{
                let oldNode = sceneView.scene.rootNode.childNodes.first
                sceneView.scene.rootNode.replaceChildNode(oldNode!, with: currentNode!)
            }
            self.title = workout.name
            self.descriptionLabel.text = newWorkout.modelDescription
        }
    }
    
    func disappearTapToStartView() {
        UIView.animate(withDuration: Animation.durationForHidingLabel) { self.tapToStartView.set(alpha: 0) }
    }
    
    
    @IBAction func nextWorkout(_ sender: Any) {
        if(index == 8){
            nextButton.setTitle("انهاء", for: .normal)
            self.index = self.index!+1
            return
        }
        else if(index == 9){ finishGame(); return}
        
        self.index = self.index!+1
        self.workout = WorkoutModel().getWorkoutData()[self.index!]
        guard let hitResult = self.result!.first else { return }
        addWorkoutNode(hitResult: hitResult)
        self.swipeView.alpha = 0
    }
    
    func finishGame(){
        
        if(currentNode != nil){
            let time = startTime!.timeIntervalSinceNow
            let score = abs(time.nextUp)
            
            print(score)
            // Update player result on database
            let id = (Auth.auth().currentUser?.uid)!
            let gid = currentGame?.gID
            Database.database().reference().child("GameParticipants").child(gid!).child(id).updateChildValues(["Result":score])
                
            // move back to previous controller
            let gameView = self.storyboard?.instantiateViewController(withIdentifier: "GameViewController") as! GameViewController
            gameView.initializeGame(g: currentGame!)
            self.navigationController?.pushViewController(gameView, animated: true)
        }

        
        
    }
    /*
    func raycastQuery(from point: CGPoint,
             allowing target: ARRaycastQuery.Target,
             alignment: ARRaycastQuery.TargetAlignment) -> ARRaycastQuery?{

    }*/
    
    @objc func didTap(withGestureRecognizer recognizer: UIGestureRecognizer) {
        if currentNode == nil {
            disappearTapToStartView()
            let tapPoint = recognizer.location(in: sceneView)
            
            var ray = sceneView.raycastQuery(from: tapPoint, allowing: .estimatedPlane, alignment: .vertical)
            print("Raycast:\(ray)")
            self.result = sceneView.hitTest(tapPoint, types: .existingPlaneUsingExtent)
            if result!.count == 0 {
                return
                   
            }
    
            guard let hitResult = result?.first else { return }
            addWorkoutNode(hitResult: hitResult)
            
            self.swipeView.alpha = 1
            // Initialize start time
            startTime = Date()
        }
    }
    @objc func didZoom(withGestureRecognizer recognizer: UIPinchGestureRecognizer){
        if recognizer.numberOfTouches == 2{
            
            if((currentNode?.scale.x)! <= 0.0006617919 && recognizer.scale<1){
                return
            }
            if((currentNode?.scale.x)! >= 0.010681649 && recognizer.scale>1){
                return
            }
            
            var factor = recognizer.scale
            var x = currentNode?.scale.x
            var y = currentNode?.scale.y
            var z = currentNode?.scale.z

            x = Float(factor)*x!
            y = Float(factor)*y!
            z = Float(factor)*z!
            
            currentNode?.scale = SCNVector3(x:x!, y:y!, z:z!)
            
        }
    }
    @objc func didSwipe(withGestureRecognizer recognizer: UISwipeGestureRecognizer){
        
        if recognizer.direction == .right{
            nextWorkout(self)
        }
        
    }
    
}

//ARSessionObserver
extension WorkoutViewController {
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        if let arError = error as? ARError {
            switch arError.errorCode {
            case 102:
                configuration.worldAlignment = .gravity
                restartSessionWithoutDelete()
            default:
                restartSessionWithoutDelete()
            }
        }
    }
    
    
    func restartSessionWithoutDelete() {
        // restart session with different alignment
        sceneView.session.pause()
        sceneView.session.run(configuration, options: [
            .resetTracking,
            .removeExistingAnchors])
    }
    
}
