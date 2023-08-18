//
//  ViewController.swift
//  bau-cua
//
//  Created by Lam Huynh on 15/08/2023.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    let BUTTON_PLAY: String = "btnPlay"
    let IMG_LEFT_DOOR: String = "left-door"
    let IMG_RIGHT_DOOR: String = "right-door"
    let IMG_BAU: String = "bau"
    let IMG_CA: String = "ca"
    let IMG_CUA: String = "cua"
    let IMG_GA: String = "ga"
    let IMG_NAI: String = "nai"
    let IMG_TOM: String = "tom"
    let IMG_BACKGROUND: String = "background"

    var screenWidth: CGFloat?
    var screenHeight: CGFloat?
    var leftDoorView: UIImageView?
    var rightDoorView: UIImageView?
    var firstAnimalView: UIImageView?
    var secondAnimalView: UIImageView?
    var thirdAnimalView: UIImageView?
    var dino: UIImageView?
    var coin: UIImageView?
    var animalArray: [String]?
    var dinoImages: [UIImage]?
    var coinImages: [UIImage]?
    
    var audio: AVPlayer?
    
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
        dinoImages = createImageArray(imageAmount: 8, imagePrefix: "run")
        coinImages = createImageArray(imageAmount: 8, imagePrefix: "coin")
        
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
                
        // running dino
        dino = UIImageView(
            frame: CGRect(
                x: 0 - screenWidth! / 4,
                y: screenHeight! - btnPlay.frame.size.height * 3.5,
                width: self.screenWidth! / 100 * 30,
                height: self.screenHeight! / 100 * 40
            )
        )
        dino?.image = UIImage(named: "run1")
        view.addSubview(dino!)
        
        // scrolling coin
        coin = UIImageView(
            frame: CGRect(
                x: 0 - screenWidth! / 10,
                y: screenHeight! / 100 * 70,
                width: self.screenWidth! / 100 * 10,
                height: self.screenHeight! / 100 * 20
            )
        )
        coin?.image = UIImage(named: "coin1")
        view.addSubview(coin!)
    }
    
    @IBAction func newGame(_ sender: Any) {
        playSound(audioName: "click-button")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            UIView.animate(withDuration: 3) { [self] in
                leftDoorView?.frame.origin.x = 0
                rightDoorView?.frame.origin.x = screenWidth! / 2
                playSound(audioName: "close-door")
            } completion: { Bool in
                UIView.animate(withDuration: 3) { [self] in
                    playSound(audioName: "wheel-spin")
                    activateAnimation(imageView: coin!, images: coinImages!)
                    coin?.frame.origin.x = view.frame.width + (dino?.frame.width)!
                    activateAnimation(imageView: dino!, images: dinoImages!)
                    dino?.frame.origin.x = view.frame.width
                    Timer.scheduledTimer(timeInterval: 3, target: self,
                                         selector: #selector(createNewRound),
                                         userInfo: nil, repeats: false)
                }
            }
            self.coin?.frame.origin.x = 0 - self.screenWidth! / 10
            self.dino?.frame.origin.x = 0 - (self.coin?.frame.width)! - self.screenWidth! / 4
        }
    }
    
    @objc func createNewRound() {
        randomAnimal(animalView: firstAnimalView!)
        randomAnimal(animalView: secondAnimalView!)
        randomAnimal(animalView: thirdAnimalView!)
        openDoor()
    }
    
    private func openDoor() {
        playSound(audioName: "open-door")
        UIView.animate(withDuration: 3) { [self] in
            leftDoorView?.frame.origin.x = 0 - screenWidth!/2
            rightDoorView?.frame.origin.x = screenWidth!
        }
    }
    
    private func randomAnimal(animalView:UIImageView) {
        let randomNumber:Int = Int.random(in: 0..<animalArray!.count)
        animalView.image = UIImage(named: animalArray![randomNumber])
    }
    
    private func createImageArray(imageAmount: Int, imagePrefix: String) -> [UIImage] {
        var imageArray: [UIImage] = []
        
        for index in 1...imageAmount {
            let imageName = "\(imagePrefix)\(index)"
            let image = UIImage(named: imageName)!
            imageArray.append(image)
        }
        
        return imageArray
    }

    private func activateAnimation(imageView:UIImageView, images:[UIImage]) {
        imageView.animationDuration = 0.5
        imageView.animationRepeatCount = 15
        imageView.animationImages = images
        imageView.startAnimating()
    }
    
    private func playSound(audioName: String) {
        let url = Bundle.main.url(forResource: audioName, withExtension: "mp3")
        audio = AVPlayer.init(url: url!)
        audio?.volume = 1.5
        audio?.play()
    }
}
