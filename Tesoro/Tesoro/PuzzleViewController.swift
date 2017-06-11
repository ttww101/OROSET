//
//  PuzzleViewController.swift
//  Tesoro
//
//  Created by Lucy on 2017/6/10.
//  Copyright © 2017年 Cu. All rights reserved.
//

import UIKit
import ImagePicker
import AVFoundation

class PuzzleViewController: UIViewController, ImagePickerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    let imagePicker = UIImagePickerController()
    private var audioPlayer: AVAudioPlayer?
    var timer: Timer?
    
    let upds = [-1,1,-1,-1,1,1,1]
    let location = [1,3,2,2,3,4,6]
    let sounds = ["pianoC","pianoA","pianoB","pianoB","pianoA","pianoG","pianoE"]
    var imageView : UIImageView = UIImageView()
    var soundIndex = 0
    @IBOutlet var questionView: UIView!
    enum Question: String{
        case cabbage = "cabbage"
        case forest = "forest"
        case juice = "juice"
    }
    
    var questionName = Question.cabbage
    
    @IBAction func openCamera(_ sender: Any) {
        imagePicker.delegate = self
        print("camera")
        let imagePickerController = ImagePickerController()
        imagePickerController.imageLimit = 1
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    
    @IBOutlet weak var cameraButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showQuestion()
    }
    
    func playAudio(sound: String) {
        let alertSound = URL(fileURLWithPath: Bundle.main.path(forResource: sound, ofType: "mp3")!)
        try! AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
        try! AVAudioSession.sharedInstance().setActive(true)
        try! audioPlayer = AVAudioPlayer(contentsOf: alertSound)
        audioPlayer!.prepareToPlay()
        audioPlayer!.play()
    }
    
    func showQuestion () {
        switch questionName{
        case .cabbage:
            print("五線譜")
            creatFootstep()
            timer = Timer.scheduledTimer(timeInterval: 0.7, target: self, selector: #selector(play), userInfo: nil, repeats: true)
        case .forest:
            print("森林")
        case .juice:
            print("果汁")
        }
    }
    
    func creatFootstep() {
        imageView  = UIImageView(frame:CGRect(x:questionView.frame.origin.x - 10,
                                              y:questionView.frame.origin.y,
                                              width:343,
                                              height:569 / 2.5));
        imageView.image = UIImage(named:"footstep")
        questionView.addSubview(imageView)
    }
    
    func play() {
        if soundIndex < sounds.count {
            playAudio(sound: sounds[soundIndex])
            let index = soundIndex + 1
            if upds[index - 1] > 0 {
                var quarternoteVuew : UIImageView
                quarternoteVuew  = UIImageView(frame:CGRect(x:40 * index + 5,
                                                            y:16 * location[index - 1],
                                                            width:48,
                                                            height:100));
                quarternoteVuew.image = UIImage(named:"quarternote")
                imageView.addSubview(quarternoteVuew)
            }else {
                var quarternoteVuew : UIImageView
                quarternoteVuew  = UIImageView(frame:CGRect(x:40 * index + 5,
                                                            y:16 * location[index - 1] + 55,
                                                            width:48,
                                                            height:100));
                quarternoteVuew.image = UIImage(named:"quarternote")
                quarternoteVuew.image = UIImage(cgImage: quarternoteVuew.image!.cgImage!, scale: CGFloat(1.0), orientation: .down)
                imageView.addSubview(quarternoteVuew)
            }
            
            soundIndex += 1
        }else {
            timer!.invalidate()
        }
    }
    
    func openCamera() {
        print("camera")
        let imagePickerController = ImagePickerController()
        imagePickerController.imageLimit = 1
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func setupViewController() {
        
        
        
    }
    
    
    func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        imagePicker.dismiss(animated: true, completion: nil)
        present(self.imagePicker, animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            TSGVApiManager.share.compareImg(with: pickedImage, ans: "airplane", comp: { (error, isTureAns) in
                if isTureAns {
                    print("正確答案")
                }else {
                    print("錯誤")
                }
            })
        }
        dismiss(animated: true, completion: nil)
    }
    
    func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        imagePicker.dismiss(animated: true, completion: nil)
        TSGVApiManager.share.compareImg(with: images[0], ans: "airplane") { (error, isTrue) in
            if isTrue {
                print("正確")
            }else {
                print("錯誤")
            }
        }
    }
    func cancelButtonDidPress(_ imagePicker: ImagePickerController) {
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
}
