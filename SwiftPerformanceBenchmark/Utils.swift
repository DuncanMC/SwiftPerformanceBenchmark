//
//  Utils.swift
//  SwiftPerformanceBenchmark
//
//  Created by Duncan Champney on 3/31/15.
//  Copyright (c) 2015 Duncan Champney. All rights reserved.
//

import Foundation

func intervalAsHHMMSS(interval: NSTimeInterval) -> String
{
  let hours = Int(interval/3600)
  let minutes = Int(Int(interval)/60) % 60
  let seconds = interval % 60
  return String(format: "%02dh %02dm %02.02fs", hours, minutes, seconds)
}
