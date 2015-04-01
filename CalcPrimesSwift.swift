//
//  CalcPrimesSwift.swift
//  SwiftPerformanceBenchmark
//
//  Created by Duncan Champney on 4/1/15.
//  Copyright (c) 2015 Duncan Champney. All rights reserved.
//

import Foundation

private let _theCalcPrimesSwiftInstance: CalcPrimesSwift = CalcPrimesSwift()

class CalcPrimesSwift: NSObject, CalcPrimesProtocol
{
  
  class func sharedInstance() -> CalcPrimesProtocol
  {
    return _theCalcPrimesSwiftInstance
  }
  
  func calcPrimesWithComputeRecord(aComputeRecord: ComputeRecord!, withUpdateDisplayBlock theUpdateDisplayBlock: updateDisplayBlock!, andCompletionBlock theCalcPrimesCompletionBlock: calcPrimesCompletionBlock!)
  {
    
  }
}