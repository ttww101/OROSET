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
import Spring

class PuzzleViewController: UIViewController, ImagePickerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    let imagePicker = UIImagePickerController()
    private var audioPlayer: AVAudioPlayer?
    var timer: Timer?
    var mask: UIImageView = UIImageView()
    var mmmm: SpringImageView = SpringImageView()
    var viewS: SpringView = SpringView()
    let upds = [-1,1,-1,-1,1,1,1]
    let location = [1,3,2,2,3,4,6]
    var indexForMask = 0
    let masks = [2,5,7,8,1,0]
    let sounds = ["pianoC","pianoA","pianoB","pianoB","pianoA","pianoG","pianoE"]
    var imageView : UIImageView = UIImageView()
    var imageView2 : UIImageView = UIImageView()
    var soundIndex = 0
    var myScore = 0
    @IBOutlet var questionView: SpringView!
    enum Question: String{
        case cabbage = "cabbage"
        case forest = "forest"
        case juice = "juice"
        case special = "special"
    }
    
    var questionName = Question.special
    var questionNameStr = ""
    
    @IBAction func openCamera(_ sender: Any) {
        if questionName == .special {
            
            let alertController = UIAlertController(
                title: "□LL□HEBE□T□□ID",
                message: "請填空",
                preferredStyle: .alert)
            
            // 建立兩個輸入框
            alertController.addTextField {
                (textField: UITextField!) -> Void in
                textField.placeholder = "帳號"
            }
            
            // 建立[取消]按鈕
            let cancelAction = UIAlertAction(
                title: "取消",
                style: .cancel,
                handler: nil)
            alertController.addAction(cancelAction)
            
            // 建立[登入]按鈕
            let okAction = UIAlertAction(
                title: "輸入",
                style: UIAlertActionStyle.default) {
                    (action: UIAlertAction!) -> Void in
                    let acc =
                        (alertController.textFields?.first)!
                            as UITextField
                    
                    if(acc.text?.caseInsensitiveCompare("ATSEN") == ComparisonResult.orderedSame || acc.text?.caseInsensitiveCompare("ALLTHEBESTENID") == ComparisonResult.orderedSame){
                        print("成功")
                    }else {
                        print("失敗")
                    }
                    
//                    print("輸入的帳號為：\(acc.text)")
//                    print("輸入的密碼為：\(password.text)")
            }
            alertController.addAction(okAction)
            
            // 顯示提示框
            self.present(
                alertController,
                animated: true,
                completion: nil)
            
            
        }else{
            imagePicker.delegate = self
            print("camera")
            let imagePickerController = ImagePickerController()
            imagePickerController.imageLimit = 1
            imagePickerController.delegate = self
            present(imagePickerController, animated: true, completion: nil)
        }

    }
    
    @IBOutlet weak var cameraButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if questionNameStr != "",
            let name  = Question(rawValue: questionNameStr){
            questionName = name
        }
        
        showQuestion()
        if questionName == .special {
            cameraButton.setTitle("□LL□HEBE□T□□ID", for: .normal)
        }else {
            cameraButton.setTitle("TakePhoto", for: .normal)
        }
        
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
            creatForest()
        case .juice:
            print("果汁")
            creatJuice()
        case .special:
            print("特殊關卡")
            creatSpecial()
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
    
    func creatForest() {
        imageView  = UIImageView(frame:CGRect(x:questionView.frame.origin.x - 40,
                                              y:questionView.frame.origin.y + 50,
                                              width:questionView.frame.width * 1.2,
                                              height:questionView.frame.width * 1.2));
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named:"mummyQuestion")
        questionView.addSubview(imageView)
        
        mmmm = SpringImageView(frame:CGRect(x:questionView.frame.origin.x + 54,
                                            y:questionView.frame.origin.y + 163,
                                            width:questionView.frame.width * 0.65,
                                            height:questionView.frame.width * 0.65));
        mmmm.image = UIImage(named:"puzzleMask")
        questionView.addSubview(mmmm)
        
        let btn = UIButton(type: .custom) as UIButton
        btn.backgroundColor = .blue
        btn.setTitle("翻轉", for: .normal)
        btn.frame = CGRect(x: 100, y: 500, width: 200, height: 100)
        btn.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        self.view.addSubview(btn)
    }
    
    func creatJuice() {
        imageView  = UIImageView(frame:CGRect(x:questionView.frame.origin.x - 10,
                                              y:questionView.frame.origin.y,
                                              width:343,
                                              height:569 / 2.5));
        imageView.image = UIImage(named:"Forest-Wall-Mural")?
            .waterMarkedImage(waterMarkText: "2017/06/11 13:00")
        questionView.addSubview(imageView)
    }
    
    func creatSpecial() {
        imageView  = UIImageView(frame:CGRect(x:questionView.frame.origin.x - 40,
                                              y:questionView.frame.origin.y + 170,
                                              width:questionView.frame.width * 1.2,
                                              height:questionView.frame.width * 1.2));
        imageView.image = UIImage(named:"special")
        
        imageView2  = UIImageView(frame:CGRect(x:questionView.frame.origin.x - 10,
                                              y:questionView.frame.origin.y ,
                                              width:questionView.frame.width ,
                                              height:questionView.frame.width * 0.7));
        imageView2.image = UIImage(named:"blood")
        imageView.contentMode = .scaleAspectFit
        imageView2.contentMode = .scaleAspectFit
        questionView.addSubview(imageView)
        questionView.addSubview(imageView2)
    }
    
    
    func buttonAction(sender: UIButton!) {
        if indexForMask < masks.count {
            maskChangeTo(to: masks[indexForMask])
            indexForMask += 1
        }else{
            maskChangeTo(to: masks[0])
            indexForMask = 0
        }
      
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
            
            //                        self.questionView.animation = "flipX"
            //                        self.questionView.curve = "saseInOut"
            //                        self.questionView.duration = 1.0
            //                        self.questionView.animateNext {
            //                            //鏡向左
            //                            self.questionView.transform = CGAffineTransform(scaleX: -1,y: 1);
            //                        }
        }
    }
    
    func maskChangeTo(to: Int) {
//        let masks = [2,5,7,8,1,0]
        mmmm.animation = "pop"
        mmmm.curve = "spring"
        mmmm.duration = 1.0
        switch to {
        case 0:
            //向右90
//            mmmm.animation = "flipX"
//            mmmm.curve = "saseInOut"
//            mmmm.duration = 1.0
            
            UIView.animate(withDuration: 0.5, delay: 0.0, options: UIViewAnimationOptions.transitionFlipFromLeft, animations: {
                let angle = 0 * CGFloat.pi / 180
                self.mmmm.transform = CGAffineTransform(rotationAngle: CGFloat(angle));
                self.mmmm.layoutIfNeeded()
            }, completion: nil)
            
//            mmmm.animateNext {
//                let angle = 0 * CGFloat.pi / 180
//                self.mmmm.transform = CGAffineTransform(rotationAngle: CGFloat(angle));
//            }
        case 1:
            //向右90
//            mmmm.animation = "flipX"
//            mmmm.curve = "saseInOut"
//            mmmm.duration = 1.0
            
            UIView.animate(withDuration: 0.5, delay: 0.0, options: UIViewAnimationOptions.transitionFlipFromRight, animations: {
                let angle = 90 * CGFloat.pi / 180
                self.mmmm.transform = CGAffineTransform(rotationAngle: CGFloat(angle));
                self.mmmm.layoutIfNeeded()
            }, completion: nil)
            
//            mmmm.animateNext {
//                let angle = 90 * CGFloat.pi / 180
//                self.mmmm.transform = CGAffineTransform(rotationAngle: CGFloat(angle));
//            }
        //                self.mmmm.transform = CGAffineTransform(scaleX: -1,y: 1);
        case 2:
            //向左90
            UIView.animate(withDuration: 0.5, delay: 0.0, options: UIViewAnimationOptions.transitionFlipFromLeft, animations: {
                let angle = -90 * CGFloat.pi / 180
                self.mmmm.transform = CGAffineTransform(rotationAngle: CGFloat(angle));
                self.mmmm.layoutIfNeeded()
            }, completion: nil)
        case 3:
            //鏡向左
//            mmmm.animation = "flipX"
//            mmmm.curve = "saseInOut"
//            mmmm.duration = 1.0
            mmmm.animateNext {
                self.mmmm.transform = CGAffineTransform(scaleX: -1,y: 1);
            }
        case 4:
            //鏡向上
//            mmmm.animation = "flipX"
//            mmmm.curve = "saseInOut"
//            mmmm.duration = 1.0
            mmmm.animateNext {
                self.mmmm.transform = CGAffineTransform(scaleX: 1,y: -1);
            }
        case 5:
            //鏡向上
            self.mmmm.image = UIImage(named:"st2")
//            mmmm.animation = "flipX"
//            mmmm.curve = "saseInOut"
//            mmmm.duration = 1.0
            mmmm.animateNext {
                let angle = -90 * CGFloat.pi / 180
                self.mmmm.transform = CGAffineTransform(rotationAngle: CGFloat(angle));
            }
        case 6:
//            mmmm.animation = "flipX"
//            mmmm.curve = "saseInOut"
//            mmmm.duration = 1.0
            mmmm.animateNext {
                let angle = -90 * CGFloat.pi / 180
                self.mmmm.transform = CGAffineTransform(rotationAngle: CGFloat(angle));
            }
        case 7:
//            mmmm.animation = "flipX"
//            mmmm.curve = "saseInOut"
//            mmmm.duration = 1.0
            
            UIView.animate(withDuration: 0.5, delay: 0.0, options: UIViewAnimationOptions.transitionCurlUp, animations: {
                let angle = -180 * CGFloat.pi / 180
                self.mmmm.transform = CGAffineTransform(rotationAngle: CGFloat(angle));
                self.mmmm.layoutIfNeeded()
            }, completion: nil)
            
            
//            mmmm.animateNext {
//                let angle = -180 * CGFloat.pi / 180
//                self.mmmm.transform = CGAffineTransform(rotationAngle: CGFloat(angle));
//            }
        case 8:
            mmmm.image = UIImage(named:"puzzleMask")
//            mmmm.animation = "flipX"
//            mmmm.curve = "saseInOut"
//            mmmm.duration = 1.0
            mmmm.animateNext {
                let angle = -180 * CGFloat.pi / 180
                self.mmmm.transform = CGAffineTransform(rotationAngle: CGFloat(angle));
            }
        default:
            self.mmmm.transform = CGAffineTransform(scaleX: 1,y: 1);
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
            TSGVApiManager.share.compareImg(with: pickedImage, ans: self.questionNameStr, comp: { (error, isTureAns) in
                if isTureAns {
                    TSGFirebaseManager.share.updateScore(score: self.myScore + 1)
                    print("正確答案")
                    self.dismiss(animated: true, completion: nil)
                    
                }else {
                    print("錯誤")
                }
            })
        }
        dismiss(animated: true, completion: nil)
    }
    
    func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        imagePicker.dismiss(animated: true, completion: nil)
        TSGVApiManager.share.compareImg(with: images[0], ans: self.questionNameStr) { (error, isTrue) in
            if isTrue {
                  TSGFirebaseManager.share.updateScore(score: self.myScore + 1)
                print("正確")
                self.dismiss(animated: true, completion: nil)
                
            }else {
                print("錯誤")
            }
        }
    }
    func cancelButtonDidPress(_ imagePicker: ImagePickerController) {
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
}

extension UIImage{
    
    //水印位置枚举
    enum WaterMarkCorner{
        case TopLeft
        case TopRight
        case BottomLeft
        case BottomRight
    }
    
    //添加水印方法
    func waterMarkedImage(waterMarkText:String, corner:WaterMarkCorner = .BottomRight,
                          margin:CGPoint = CGPoint(x: 20, y: 20),
                          waterMarkTextColor:UIColor = UIColor.yellow,
                          waterMarkTextFont:UIFont = UIFont.systemFont(ofSize: 30),
                          backgroundColor:UIColor = UIColor.clear) -> UIImage{
        
        let textAttributes = [NSForegroundColorAttributeName:waterMarkTextColor,
                              NSFontAttributeName:waterMarkTextFont,
                              NSBackgroundColorAttributeName:backgroundColor]
        let textSize = NSString(string: waterMarkText).size(attributes: textAttributes)
        var textFrame = CGRectMake(0, 0, textSize.width, textSize.height)
        
        let imageSize = self.size
        switch corner{
        case .TopLeft:
            textFrame.origin = margin
        case .TopRight:
            textFrame.origin = CGPoint(x: imageSize.width - textSize.width - margin.x, y: margin.y)
        case .BottomLeft:
            textFrame.origin = CGPoint(x: margin.x, y: imageSize.height - textSize.height - margin.y)
        case .BottomRight:
            textFrame.origin = CGPoint(x: imageSize.width - textSize.width - margin.x,
                                       y: imageSize.height - textSize.height - margin.y)
        }
        
        // 开始给图片添加文字水印
        UIGraphicsBeginImageContext(imageSize)
        self.draw(in: CGRectMake(0, 0, imageSize.width, imageSize.height))
        NSString(string: waterMarkText).draw(in: textFrame, withAttributes: textAttributes)
        
        let waterMarkedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return waterMarkedImage!
    }
    
    func CGRectMake(_ x: CGFloat, _ y: CGFloat, _ width: CGFloat, _ height: CGFloat) -> CGRect {
        return CGRect(x: x, y: y, width: width, height: height)
    }
}
