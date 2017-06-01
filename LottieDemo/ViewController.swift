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
    @IBOutlet weak var textFileShowFile: NSTextField!
    
    @IBOutlet weak var viewLine: NSView!
    
    var animation = LOTAnimationView()
    var animationLoop = LOTAnimationView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setInitialObject()
    }

    func setInitialObject(){
        viewLine.layer?.backgroundColor = NSColor.lightGray.cgColor
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
            
            let result = dialog.url
            
            if result != nil, let path = result?.path {
                textFileShowFile.stringValue = path
                setAnimationURL(path: path)
            }else{
                return
            }
        }
    }
    
    func setInitialAnimation(){
        self.showAnimation(image: self.imageResult)
        self.showAnimationLoop(image: self.imageResultLoop)
    }
    
    func setAnimationURL(path:String){
        
        animation.removeFromSuperview()
        animationLoop.removeFromSuperview()
        
        animation = LOTAnimationView(contentsOf:URL(fileURLWithPath:path))
        animationLoop = LOTAnimationView(contentsOf:URL(fileURLWithPath:path))
        
        setInitialAnimation()
    }
    
    @IBAction func tapOnImageResult(_ sender: Any) {
        
        animation.removeFromSuperview()
        self.showAnimation(image: self.imageResult)
    }
    
    func showAnimation(image:NSImageView){
        
        animation.frame = CGRect(x: 0, y: 0, width: imageResult.frame.size.width, height: imageResult.frame.size.height)
        animation.contentMode = .scaleAspectFit
        image.addSubview(animation)
        animation.play(completion: { finished in
        })
    }
    
    func showAnimationLoop(image:NSImageView){
        
        animationLoop.contentMode = .scaleAspectFit
        animationLoop.frame = CGRect(x: 0, y: 0, width: imageResult.frame.size.width, height: imageResult.frame.size.height)
        image.addSubview(animationLoop)
        
        animationLoop.play(completion: { finished in
            self.showAnimationLoop(image: self.imageResultLoop)
        })
    }
}

