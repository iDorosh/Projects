/**
 * Appcelerator Titanium Mobile
 * Copyright (c) 2009-2016 by Appcelerator, Inc. All Rights Reserved.
 * Licensed under the terms of the Apache Public License
 * Please see the LICENSE included with this distribution for details.
 * 
 * WARNING: This is generated code. Modify at your own risk and without support.
 */

#if IS_XCODE_7_1
#ifdef USE_TI_UIIOSLIVEPHOTOVIEW
#import "TiUIView.h"
#import "TiUIiOSLivePhoto.h"
#import <PhotosUI/PhotosUI.h>

@interface TiUIiOSLivePhotoView : TiUIView<PHLivePhotoViewDelegate> {
    TiDimension width;
    TiDimension height;
    CGFloat autoHeight;
    CGFloat autoWidth;
}

@property(nonatomic,retain) PHLivePhotoView *livePhotoView;

@end
#endif
#endif