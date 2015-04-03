//
//  ViewController.swift
//  SwiftPerformanceBenchmark
//
//  Created by Duncan Champney on 3/31/15.
//  Copyright (c) 2015 Duncan Champney. All rights reserved.
//

import Cocoa


class ViewController: NSViewController
{
  
  //weak var progressTimer: NSTimer?
  //-------------------------------------------------------------------------------------------------------
  // MARK: - IBOutlets -
  //-------------------------------------------------------------------------------------------------------
  
  
  @IBOutlet weak var primesToCalculateField: NSTextField!
  
  @IBOutlet weak var totalTimeSwiftField: NSTextField!
  
  @IBOutlet weak var totalTimeObjCField: NSTextField!
  
  @IBOutlet weak var computeInObjCCheckbox: NSButton!
  
  @IBOutlet weak var calculateButton: NSButton!
  @IBOutlet weak var progressIndicator: NSProgressIndicator!
  
  @IBOutlet weak var statusLabel: NSTextField!
  //-------------------------------------------------------------------------------------------------------
  // MARK: - Other Properties -
  //-------------------------------------------------------------------------------------------------------
  var statusMessage: String? = ""
    {
    didSet(oldValue)
    {
      if statusMessage != nil
      {
      statusLabel.stringValue = statusMessage!
      }
      else
      {
        statusLabel.stringValue = ""
      }
    }
  }

  var calculationsRunning: Bool = false
  var theComputeSettings: ComputeRecord = ComputeRecord()
    {
    didSet(oldValue)
    {
      self.showSettings(self)
    }
  }
  
  //-------------------------------------------------------------------------------------------------------
  
  var foo: Int = 12
  
  //-------------------------------------------------------------------------------------------------------
  
  var startTime: NSTimeInterval?
  var calcPrimesBlocks: [dispatch_block_t] = [dispatch_block_t]()
  
  //-------------------------------------------------------------------------------------------------------
  // MARK: - View controller methods -
  //-------------------------------------------------------------------------------------------------------
  
  override func viewDidLoad()
  {
    super.viewDidLoad()
    self.showSettings(self)
    statusLabel.stringValue = ""
  }
  
  //-------------------------------------------------------------------------------------------------------
  
  override var representedObject: AnyObject? {
    didSet {
      // Update the view, if already loaded.
    }
  }
  
  //-------------------------------------------------------------------------------------------------------
  // MARK: - IBAction methods -
  //-------------------------------------------------------------------------------------------------------
  
  @IBAction func showSettings(sender: AnyObject)
  {
    totalTimeSwiftField.stringValue = intervalAsHHMMSS(theComputeSettings.swift_totalTime)
    totalTimeObjCField.stringValue = intervalAsHHMMSS(theComputeSettings.objC_totalTime)
    calculateButton.enabled =
      !calculationsRunning &&
      (
        theComputeSettings.doCalculationsInSwift ||
          theComputeSettings.doCalculationsInObjC)
    if !calculationsRunning
    {
      if theComputeSettings.swift_totalTime > 0  && theComputeSettings.objC_totalTime > 0
      {
        if theComputeSettings.swift_totalTime > theComputeSettings.objC_totalTime
        {
          let valueString = String(format: "%.2f",
            (theComputeSettings.swift_totalTime /
            theComputeSettings.objC_totalTime))
          statusMessage = "Swift took \(valueString) times longer."
        }
        else
        {
          let valueString = String(format: "%.2f",
            (theComputeSettings.objC_totalTime /
             theComputeSettings.swift_totalTime ))
          statusMessage = "Objective-C took \(valueString) times longer."
          
        }
        
      }
      else if theComputeSettings.swift_totalTime > 0  && theComputeSettings.objC_totalTime > 0
      {
        statusMessage = "Calculations complete."
      }
      else
      {
        statusMessage = ""
      }
      
      
      progressIndicator.doubleValue = 0
    }
  }
  
  //-------------------------------------------------------------------------------------------------------
  
  @IBAction func CalculatePrimes(sender: NSButton)
  {
    //println("In \(__FUNCTION__)")
    primesToCalculateField.window?.makeFirstResponder(nil)
    progressIndicator.doubleValue = 0
    calculateButton.enabled = false
    
    //This code calculates primes using the Objective-C code.
    theComputeSettings.objC_totalCalculated = 0
    theComputeSettings.objC_primesPerSecond = 0
    theComputeSettings.objC_totalTime = 0

    theComputeSettings.swift_totalCalculated = 0
    theComputeSettings.swift_primesPerSecond = 0
    theComputeSettings.swift_totalTime = 0
    calculationsRunning = true
    
    if theComputeSettings.doCalculationsInObjC
    {
      calcPrimesBlocks.append(
        {
          [weak self] in
          if let requiredSelf = self
          {
            requiredSelf.statusMessage = "Calculating primes in Objective-C"
            requiredSelf.progressIndicator.doubleValue = 0

            let theCalcPrimesObjC:CalcPrimesProtocol = CalcPrimesObjC.sharedInstance()
            
            theCalcPrimesObjC.calcPrimesWithComputeRecord(requiredSelf.theComputeSettings,
              withUpdateDisplayBlock:
              {
                //println("In updateDisplayBlock")
                let progressValue =  Double(requiredSelf.theComputeSettings.objC_totalCalculated)/Double(requiredSelf.theComputeSettings.totalToCalculate) * Double(1000)
                
                
                requiredSelf.progressIndicator.doubleValue = progressValue
                requiredSelf.showSettings(requiredSelf)
              },
              andCompletionBlock:
              {
                let totalTimeString = intervalAsHHMMSS(requiredSelf.theComputeSettings.objC_totalTime)
                let usingArraysString = requiredSelf.theComputeSettings.objC_useArrayObjects ?
                  "using NSArrays " : ""
                println("\nCalculating primes \(usingArraysString)in Obj-C took \(totalTimeString)")
                if requiredSelf.calcPrimesBlocks.count > 0
                {
                  dispatch_async(
                    dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0),
                    requiredSelf.calcPrimesBlocks.removeLast()
                  )
                }
                else
                {
                  requiredSelf.calculationsRunning = false
                  requiredSelf.showSettings(requiredSelf)
                }
              }
            )
          }
        }
      )
    }
    if theComputeSettings.doCalculationsInSwift
    {
      calcPrimesBlocks.append(
        {
          [weak self] in
          if let requiredSelf = self
          {
            requiredSelf.statusMessage = "Calculating primes in Swift"

            requiredSelf.progressIndicator.doubleValue = 0
            let theCalcPrimesSwift:CalcPrimesProtocol = CalcPrimesSwift.sharedInstance()
            
            theCalcPrimesSwift.calcPrimesWithComputeRecord(requiredSelf.theComputeSettings,
              withUpdateDisplayBlock:
              {
                //println("In updateDisplayBlock")
                let progressValue =  Double(requiredSelf.theComputeSettings.swift_totalCalculated)/Double(requiredSelf.theComputeSettings.totalToCalculate) * Double(1000)
                
                
                requiredSelf.progressIndicator.doubleValue = progressValue
                requiredSelf.showSettings(requiredSelf)
              },
              andCompletionBlock:
              {
                let totalTimeString = intervalAsHHMMSS(requiredSelf.theComputeSettings.swift_totalTime)
                let usingArraysString = requiredSelf.theComputeSettings.swift_useArrayObjects ?
                  "using Arrays " : ""
                println("\nCalculating primes \(usingArraysString)in Swift took \(totalTimeString)")

                if requiredSelf.calcPrimesBlocks.count > 0
                {
                  dispatch_async(
                    dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0),
                    requiredSelf.calcPrimesBlocks.removeLast()
                  )
                }
                else
                {
                  requiredSelf.calculationsRunning = false
                  requiredSelf.showSettings(requiredSelf)
                }
              }
            )
          }
        }
      )
    }
    if calcPrimesBlocks.count > 0
    {
      dispatch_async(
        dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0),
        calcPrimesBlocks.removeLast()
      )
    }
  }
}

