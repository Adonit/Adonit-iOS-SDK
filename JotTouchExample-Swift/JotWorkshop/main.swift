//
//  main.swift
//  JotWorkshop
//
//  Copyright (c) 2015 Adonit. All rights reserved.
//

import Foundation
import UIKit

UIApplicationMain(
    CommandLine.argc,
    UnsafeMutableRawPointer(CommandLine.unsafeArgv)
        .bindMemory(
            to: UnsafeMutablePointer<Int8>.self,
            capacity: Int(CommandLine.argc)),
    NSStringFromClass(JotDrawingApplication.self),
    NSStringFromClass(AppDelegate.self)
)
