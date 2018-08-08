//
//  RQJsonKitConst.h
//  RQJsonKit
//
//  Created by renqiang on 2017/12/28.
//  Copyright © 2017年 renqiang. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 映射key的类型的枚举
 */
typedef enum
{
    RQMappingKeyTypeDictionary,
    RQMappingKeyTypeArray
    
}RQMappingKeyType;

typedef enum{
    RQEncodingTypeUnknown, ///< unknown
    RQEncodingTypeVoid, ///< void
    RQEncodingTypeBool, ///< bool
    RQEncodingTypeInt8, ///< char / BOOL
    RQEncodingTypeUInt8, ///< unsigned char
    RQEncodingTypeInt16, ///< short
    RQEncodingTypeUInt16, ///< unsigned short
    RQEncodingTypeInt32, ///< int
    RQEncodingTypeUInt32, ///< unsigned int
    RQEncodingTypeInt64, ///< long long
    RQEncodingTypeUInt64, ///< unsigned long long
    RQEncodingTypeFloat, ///< float
    RQEncodingTypeDouble, ///< double
    RQEncodingTypeLongDouble, ///< long double
    RQEncodingTypeObject, ///< id
    RQEncodingTypeClass, ///< Class
    RQEncodingTypeSEL, ///< SEL
    RQEncodingTypeBlock, ///< block
    RQEncodingTypePointer, ///< void*
    RQEncodingTypeStruct, ///< struct
    RQEncodingTypeUnion, ///< union
    RQEncodingTypeCString, ///< char*
    RQEncodingTypeCArray, ///< char[10] (for example)
    RQEncodingTypePropertyReadonly, ///< readonly
    RQEncodingTypePropertyCopy, ///< copy
    RQEncodingTypePropertyRetain, ///< retain
    RQEncodingTypePropertyNonatomic, ///< nonatomic
    RQEncodingTypePropertyWeak, ///< weak
    RQEncodingTypePropertyCustomGetter, ///< getter=
    RQEncodingTypePropertyCustomSetter, ///< setter=
    RQEncodingTypePropertyDynamic ///< @dynamic
}RQEncodingType;

typedef enum
{
    RQAssignmentTypeMessage,
    RQAssignmentTypeKVC
    
}RQAssignmentType;
