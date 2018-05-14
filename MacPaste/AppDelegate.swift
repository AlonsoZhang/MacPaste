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

    @objc dynamic var Copys:[[String:String]] = []
    @objc dynamic var Show = true
    
    let hotkey = JFHotkeyManager.init()
    var timer : Timer!
    
    @IBOutlet weak var window: NSWindow!
    @IBOutlet weak var tableview: NSTableView!
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        timer=Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(AppDelegate.checkPasteboard), userInfo: nil, repeats: true)
        hotkey.bind("control v", target: self, action: #selector(AppDelegate.showhide))
        hotkey.bind("cmd q", target: self, action: #selector(AppDelegate.quit))
        self.Copys = [["Copy":"Please copy your first string"]]
        self.tableview.action = #selector(AppDelegate.singleaction)
        //self.tableview.doubleAction = #selector(AppDelegate.doubleaction)
    }
    
    @objc func showhide() {
        if Show {
            Show = false
        }else{
            Show = true
            NSRunningApplication.current.activate(options: [.activateAllWindows,.activateIgnoringOtherApps])
        }
    }
    
    @objc func checkPasteboard() {
        if let lastPasteboard =  NSPasteboard.general.string(forType:.string){
            if Copys.count > 0
            {
                if lastPasteboard != Copys.first!["Copy"]{
                    Copys.insert(["Copy":lastPasteboard], at: 0)
                }
            }else{
                Copys.insert(["Copy":lastPasteboard], at: 0)
            }
            tableview.reloadData()
        }
    }
    
    @objc func singleaction() {
        let selectInt = self.tableview.selectedRow
        if selectInt > -1 {
            let copyinfo = Copys[selectInt]["Copy"]
            Copys.remove(at: selectInt)
            NSPasteboard.general.clearContents()
            NSPasteboard.general.writeObjects([copyinfo! as NSPasteboardWriting])
            showhide()
        }
    }
    
    @objc func quit() {
        NSApp.terminate(self)
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return false
    }
}

