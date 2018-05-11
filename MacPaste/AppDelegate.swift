//
//  AppDelegate.swift
//  MacPaste
//
//  Created by Alonso on 2018/5/10.
//  Copyright © 2018 Alonso. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    let hotkey = JFHotkeyManager.init()
    var timer : Timer!
    
    @IBOutlet weak var window: NSWindow!


    func applicationDidFinishLaunching(_ aNotification: Notification) {
        //hotkey.bind("cmd c", target: self, action:#selector(AppDelegate.copyaction))
        timer=Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(AppDelegate.checkPasteboard), userInfo: nil, repeats: true)
        hotkey.bind("cmd v", target: self, action: #selector(AppDelegate.pasteaction))
    }

    @objc func copyaction() {
        print("copy")
    }
    
    @objc func pasteaction() {
        print("paste")
    }
    
    @objc func checkPasteboard() {
        //let pasteboard = NSPasteboard.general
        if let ss =  NSPasteboard.general.string(forType:.string){
             print(ss)
        }
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

}

