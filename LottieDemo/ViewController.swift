//
//  ViewController.swift
//  LottieDemo
//
//  Created by pimpaporn chaichompoo on 6/1/17.
//  Copyright © 2017 Pimpaporn Chaichompoo. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    
    @IBOutlet weak var textViewInputFile: NSTextField!
    
    @IBOutlet weak var imageResult: NSImageView!
    @IBOutlet weak var imageResultLoop: NSImageView!
    @IBOutlet weak var imageResultLoopWithDelay: NSImageView!
    
    @IBOutlet weak var textFileShowFile: NSTextField!
    @IBOutlet weak var loader: NSProgressIndicator!
    
    @IBOutlet weak var viewLineHorizontal: NSView!
    @IBOutlet weak var viewLineVertical: NSView!
    
    @IBOutlet weak var textNumberDelay: NSTextField!
    @IBOutlet weak var stepper: NSStepper!
    
    var animation = LOTAnimationView()
    var animationLoop = LOTAnimationView()
    var animationLoopWithDelay = LOTAnimationView()
    
    var result:URL?
    
    var sec:Int = 1
    var isPlayAgain:Bool = false
    var loopEnable:Bool = true
    
    var numberDelay:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setInitialUI()
    }
    
    func setInitialUI(){
        
        viewLineHorizontal.layer?.backgroundColor = NSColor.lightGray.cgColor
        viewLineVertical.layer?.backgroundColor = NSColor.lightGray.cgColor
    }
    
    @IBAction func btnSelectFilePressed(_ sender: Any) {
        
        let dialog = NSOpenPanel()
        
        dialog.title                = "Choose a .json file"
        dialog.showsResizeIndicator = true
        dialog.showsHiddenFiles     = false
        dialog.canChooseDirectories = true
        dialog.canCreateDirectories = true
        dialog.allowsMultipleSelection  = true
        dialog.allowedFileTypes     = ["json"]
        
        if dialog.runModal() == NSModalResponseOK{
            
            resetValueCondition()
            
            result = dialog.url
            loader.isHidden = false
            loader.startAnimation(self)
            
            if result != nil {
                playAnimation()
            }else{
                return
            }
        }
    }
    
    func resetValueCondition() {
        
        isPlayAgain = false
        loopEnable = true
        
        imageResult.isHidden = true
        imageResultLoop.isHidden = true
        imageResultLoopWithDelay.isHidden = true
    }
    
    func playAnimation() {
        
        if isPlayAgain == false {
            textFileShowFile.stringValue = result!.path
            setAnimationURL(path: result!.path)
        }else{
            loader.isHidden = true
            imageResult.isHidden = false
            imageResultLoop.isHidden = false
            imageResultLoopWithDelay.isHidden = false
        }
        
        if loopEnable == true {
            sec = sec + 1
            self.perform(#selector(playAnimation), with: nil, afterDelay: TimeInterval(sec))
        }
    }
    
    func setInitialAnimation(){
        self.showAnimation(image: self.imageResult)
        self.showAnimationLoop(image: self.imageResultLoop)
        self.showAnimationLoopWithDelay()
    }
    
    func setAnimationURL(path:String){
        
        animation.removeFromSuperview()
        animationLoop.removeFromSuperview()
        animationLoopWithDelay.removeFromSuperview()
        
        animation = LOTAnimationView(contentsOf:URL(fileURLWithPath:path))
        animationLoop = LOTAnimationView(contentsOf:URL(fileURLWithPath:path))
        animationLoopWithDelay = LOTAnimationView(contentsOf:URL(fileURLWithPath:path))
        
        setInitialAnimation()
    }
    
    @IBAction func tapOnImageResult(_ sender: Any) {
        
        animation.removeFromSuperview()
        self.showAnimation(image: self.imageResult)
    }
    
    @IBAction func stepperPressed(_ sender: NSStepper) {
        
        print("== ",textNumberDelay.doubleValue)
        self.showAnimationLoopWithDelay()

    }
    
    func showAnimation(image:NSImageView){
        
        animation.frame = CGRect(x: 0, y: 0, width: imageResult.frame.size.width, height: imageResult.frame.size.height)
        animation.contentMode = .scaleAspectFit
        image.addSubview(animation)
        animation.play(completion: { finished in
            self.isPlayAgain = true
            self.loopEnable = false
        })
    }
    
    func showAnimationLoop(image:NSImageView){
        
        animationLoop.contentMode = .scaleAspectFit
        animationLoop.frame = CGRect(x: 0, y: 0, width: imageResult.frame.size.width, height: imageResult.frame.size.height)
        image.addSubview(animationLoop)
        
        animationLoop.play(completion: { finished in
            self.isPlayAgain = true
            self.loopEnable = false
            self.showAnimationLoop(image: self.imageResultLoop)
        })
    }
    
    func showAnimationLoopWithDelay(){
        
        animationLoopWithDelay.contentMode = .scaleAspectFit
        animationLoopWithDelay.frame = CGRect(x: 0, y: 0, width: imageResultLoopWithDelay.frame.size.width, height: imageResultLoopWithDelay.frame.size.height)
        imageResultLoopWithDelay.addSubview(animationLoopWithDelay)
        
        animationLoopWithDelay.play(completion: { finished in
            self.isPlayAgain = true
            self.loopEnable = false
            self.perform(#selector(self.showAnimationLoopWithDelay), with: nil, afterDelay: self.textNumberDelay.doubleValue)
        })
    }
}

