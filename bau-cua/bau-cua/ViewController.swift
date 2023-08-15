//
//  ViewController.swift
//  bau-cua
//
//  Created by Lam Huynh on 15/08/2023.
//

import UIKit

class ViewController: UIViewController {
    
    let BUTTON_PLAY:String = "btnPlay"
    let IMG_LEFT_DOOR:String = "left-door"
    let IMG_RIGHT_DOOR:String = "right-door"
    let IMG_BAU:String = "bau"
    let IMG_CA:String = "ca"
    let IMG_CUA:String = "cua"
    let IMG_GA:String = "ga"
    let IMG_NAI:String = "nai"
    let IMG_TOM:String = "tom"
    let IMG_BACKGROUND:String = "background"

    var screenWidth:CGFloat?
    var screenHeight:CGFloat?
    var leftDoorView:UIImageView?
    var rightDoorView:UIImageView?
    var firstAnimalView:UIImageView?
    var secondAnimalView:UIImageView?
    var thirdAnimalView:UIImageView?
    var animalArray:[String]?
    
    @IBOutlet weak var btnPlay: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // background
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: IMG_BACKGROUND)
        backgroundImage.contentMode = UIView.ContentMode.scaleToFill
        self.view.insertSubview(backgroundImage, at: 0)
        let blurredView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        blurredView.alpha = 0.55
        blurredView.frame = self.view.bounds
        backgroundImage.addSubview(blurredView)
        
        screenWidth = self.view.frame.width
        screenHeight = self.view.frame.height
        let HALF_SCREEN_WIDTH = screenWidth! / 2
        let HALF_SCREEN_HEIGHT = screenHeight! / 2
        animalArray = [IMG_BAU, IMG_CA, IMG_CUA, IMG_GA, IMG_NAI, IMG_TOM]
        
        // second animal
        secondAnimalView = UIImageView(
            frame: CGRect(
                x: screenWidth! / 8 * 3,
                y: screenHeight! / 100 * 15,
                width: screenWidth! / 4,
                height: HALF_SCREEN_HEIGHT)
        )
        secondAnimalView?.image = UIImage(named: IMG_CUA)
        view.addSubview(secondAnimalView!)
        
        // first animal
        firstAnimalView = UIImageView(
            frame: CGRect(
                x: (secondAnimalView?.frame.origin.x)!
                - (secondAnimalView?.frame.size.width)!
                - screenWidth! / 100 * 2,
                y: screenHeight! / 100 * 15,
                width: screenWidth! / 4,
                height: HALF_SCREEN_HEIGHT)
        )
        firstAnimalView?.image = UIImage(named: IMG_BAU)
        view.addSubview(firstAnimalView!)
        
        // third animal
        thirdAnimalView = UIImageView(
            frame: CGRect(
                x: (secondAnimalView?.frame.origin.x)!
                + (secondAnimalView?.frame.size.width)!
                + screenWidth! / 100 * 2,
                y: screenHeight! / 100 * 15,
                width: screenWidth! / 4,
                height: HALF_SCREEN_HEIGHT)
        )
        thirdAnimalView?.image = UIImage(named: IMG_TOM)
        view.addSubview(thirdAnimalView!)
        
        // left door view
        leftDoorView = UIImageView(
            frame: CGRect(
                x: 0 - HALF_SCREEN_WIDTH,
                y: 0,
                width: HALF_SCREEN_WIDTH,
                height: screenHeight!
            )
        )
        leftDoorView!.image = UIImage(named: IMG_LEFT_DOOR)
        view.addSubview(leftDoorView!)
        
        // right door view
        rightDoorView = UIImageView(
            frame: CGRect(
                x: screenWidth!,
                y: 0,
                width: HALF_SCREEN_WIDTH,
                height: screenHeight!
            )
        )
        rightDoorView?.image = UIImage(named: IMG_RIGHT_DOOR)
        view.addSubview(rightDoorView!)
        
        // button Play
        btnPlay.frame.size = .init(width: screenWidth! / 6, height: screenHeight! / 8)
        btnPlay.frame.origin.x = HALF_SCREEN_WIDTH - btnPlay.frame.size.width / 2
        btnPlay.frame.origin.y = screenHeight! - btnPlay.frame.size.height * 2
        btnPlay.setBackgroundImage(UIImage(named: BUTTON_PLAY), for: .normal)
        btnPlay.setTitle("", for: .normal)
    }
    
    @IBAction func newGame(_ sender: Any) {
        UIView.animate(withDuration: 3) {
            self.leftDoorView?.frame.origin.x = 0
            self.rightDoorView?.frame.origin.x = self.screenWidth!/2
        } completion: { Bool in
            Timer.scheduledTimer(timeInterval: 3, target: self,
                                 selector: #selector(self.createNewRound),
                                 userInfo: nil, repeats: false)
        }
    }
    
    @objc func createNewRound() {
        randomAnimal(animalView: firstAnimalView!)
        randomAnimal(animalView: secondAnimalView!)
        randomAnimal(animalView: thirdAnimalView!)
        
        openDoor()
    }
    
    private func openDoor() {
        UIView.animate(withDuration: 3) {
            self.leftDoorView?.frame.origin.x = 0 - self.screenWidth!/2
            self.rightDoorView?.frame.origin.x = self.screenWidth!
        }
    }
    
    private func randomAnimal(animalView:UIImageView) {
        let randomNumber:Int = Int.random(in: 0...animalArray!.count - 1)
        animalView.image = UIImage(named: animalArray![randomNumber])
    }
}
