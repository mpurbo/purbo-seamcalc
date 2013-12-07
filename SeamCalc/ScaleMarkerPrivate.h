//
//  ScaleMarkerPrivate.h
//  SeamCalc
//
//  Created by Purbo Mohamad on 12/8/13.
//  Copyright (c) 2013 Purbo Mohamad. All rights reserved.
//

#ifndef SeamCalc_ScaleMarkerPrivate_h
#define SeamCalc_ScaleMarkerPrivate_h

@interface ScaleMarker()

@property (nonatomic, readwrite, strong) NSNumber *value;
@property (nonatomic, readwrite, assign) CGFloat lengthProportion;
@property (nonatomic, readwrite, assign) CGFloat labelHeightProportion;
@property (nonatomic, readwrite, assign) BOOL labelVisible;
@property (nonatomic, readwrite, assign) BOOL primary;

@end

#endif
