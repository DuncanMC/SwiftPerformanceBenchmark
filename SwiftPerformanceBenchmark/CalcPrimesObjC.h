//
//  CalcPrimesObjC.h
//  SwiftPerformanceBenchmark
//
//  Created by Duncan Champney on 3/31/15.
//  Copyright (c) 2015 Duncan Champney. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class ComputeRecord;

@interface CalcPrimesObjC : NSTableColumn
{
  NSTimeInterval startTime;
  ComputeRecord *theComputeRecord;
}
@property (nonatomic, strong) void (^updateDisplayBlock)(void);

+ (instancetype) sharedCalcPrimesObjC;

- (void) calcPrimesWithComputeRecord: (ComputeRecord *) theComputeRecord;

@end
