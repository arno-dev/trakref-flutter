// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'asset.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Asset _$AssetFromJson(Map<String, dynamic> json) {
  return Asset(
      name: json['Name'] as String,
      assetID: json['AssetID'] as int,
      assetStatusID: json['AssetStatusID'] as int,
      assetStatus: json['AssetStatus'] as String,
      cylinderStatusID: json['CylinderStatusID'] as int,
      isCylinder: json['IsCylinder'] as bool,
      instanceID: json['InstanceID'] as int,
      instance: json['Instance'] as String,
      locationID: json['LocationID'] as int,
      location: json['Location'] as String,
      address1: json['Address1'] as String,
      address2: json['Address2'] as String,
      city: json['City'] as String,
      state: json['State'] as String,
      zipcode: json['Zipcode'] as String,
      country: json['Country'] as String,
      serialNumber: json['SerialNumber'] as String,
      tagNumber: json['TagNumber'] as String,
      materialTypeID: json['MaterialTypeID'] as int,
      materialType: json['MaterialType'] as String,
      currentGasWeightLbs: (json['CurrentGasWeightLbs'] as num)?.toDouble(),
      maxGasCapacityLbs: (json['MaxGasCapacityLbs'] as num)?.toDouble(),
      category: json['Category'] as String,
      assetCategoryID: json['AssetCategoryID'] as int,
      assetCategory: json['AssetCategory'] as String,
      assetTypeID: json['AssetTypeID'] as int,
      assetType: json['AssetType'] as String,
      assetSubtypeID: json['AssetSubtypeID'] as int,
      statusDate: json['StatusDate'] as String,
      assetSubtype: json['AssetSubtype'] as String,
      assetKindID: json['AssetKindID'] as int,
      coolingApplianceStatusID: json['CoolingApplianceStatusID'] as int,
      assetKind: json['AssetKind'] as String,
      poNumber: json['PONumber'] as String,
      leakRate: (json['LeakRate'] as num)?.toDouble(),
      lastServiceDate: json['LastServiceDate'] as String,
      workItemCount: json['WorkItemCount'] as int,
      id: json['ID'] as int,
      weightUnits: json['WeightUnits'] as String,
      workItem: (json['WorkItem'] as List)
          ?.map((e) =>
              e == null ? null : WorkItem.fromJson(e as Map<String, dynamic>))
          ?.toList());
}

Map<String, dynamic> _$AssetToJson(Asset instance) => <String, dynamic>{
      'Name': instance.name,
      'AssetID': instance.assetID,
      'AssetStatusID': instance.assetStatusID,
      'AssetStatus': instance.assetStatus,
      'CylinderStatusID': instance.cylinderStatusID,
      'IsCylinder': instance.isCylinder,
      'InstanceID': instance.instanceID,
      'Instance': instance.instance,
      'LocationID': instance.locationID,
      'Location': instance.location,
      'Address1': instance.address1,
      'Address2': instance.address2,
      'City': instance.city,
      'State': instance.state,
      'Zipcode': instance.zipcode,
      'Country': instance.country,
      'SerialNumber': instance.serialNumber,
      'TagNumber': instance.tagNumber,
      'MaterialTypeID': instance.materialTypeID,
      'MaterialType': instance.materialType,
      'CurrentGasWeightLbs': instance.currentGasWeightLbs,
      'MaxGasCapacityLbs': instance.maxGasCapacityLbs,
      'Category': instance.category,
      'AssetCategoryID': instance.assetCategoryID,
      'AssetCategory': instance.assetCategory,
      'AssetTypeID': instance.assetTypeID,
      'AssetType': instance.assetType,
      'AssetSubtypeID': instance.assetSubtypeID,
      'AssetSubtype': instance.assetSubtype,
      'AssetKindID': instance.assetKindID,
      'AssetKind': instance.assetKind,
      'PONumber': instance.poNumber,
      'LeakRate': instance.leakRate,
      'LastServiceDate': instance.lastServiceDate,
      'WorkItemCount': instance.workItemCount,
      'CoolingApplianceStatusID': instance.coolingApplianceStatusID,
      'StatusDate': instance.statusDate,
      'WorkItem': instance.workItem,
      'ID': instance.id,
      'WeightUnits': instance.weightUnits
    };
