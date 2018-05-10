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
    
    @IBOutlet weak var window: NSWindow!


    func applicationDidFinishLaunching(_ aNotification: Notification) {
        hotkey.bind("cmd c", target: self, action:#selector(AppDelegate.copyaction))
        
        hotkey.bind("cmd v", target: self, action: #selector(AppDelegate.pasteaction))
    }

    @objc func copyaction() {
        print("copy")
    }
    
    @objc func pasteaction() {
        print("paste")
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

}

