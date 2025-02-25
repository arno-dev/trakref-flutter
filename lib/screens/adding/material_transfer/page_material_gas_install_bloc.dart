import "package:flutter/material.dart";
import 'package:intl/intl.dart';
import 'package:trakref_app/constants.dart';
import 'package:trakref_app/main.dart';
import 'package:trakref_app/models/asset.dart';
import 'package:trakref_app/models/workorder.dart';
import 'package:trakref_app/repository/get_service.dart';
import 'package:trakref_app/screens/adding/service_event/page_service_event_add_bloc.dart';
import 'package:trakref_app/widget/button_widget.dart';
import 'package:trakref_app/widget/dropdown_widget.dart';

typedef SelectMaterialGasTransferDelegate = void Function(
    MaterialTransfer transfer);

class PageMaterialGasInstallBloc extends StatefulWidget {
  List<Asset> assets = [];
  final Asset currentAssetWorkedOn;
  final MaterialGasInstallType installType;
  final SelectMaterialGasTransferDelegate delegate;
  final ServiceType serviceType;

  PageMaterialGasInstallBloc(
      {@required this.serviceType,
      this.assets,
      this.currentAssetWorkedOn,
      this.installType,
      this.delegate});

  @override
  _PageMaterialGasInstallBlocState createState() =>
      _PageMaterialGasInstallBlocState();
}

class _PageMaterialGasInstallBlocState
    extends State<PageMaterialGasInstallBloc> {
  Asset _pickedAsset;
  List<Asset> _allAssets; // including Unknown asset transfer
  double _pickedAmountLbs;
  DateTime _pickedDateMaterialTransfer;
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  TextEditingController amountTextController;

  @override
  void initState() {
    amountTextController = TextEditingController();
    amountTextController.addListener(onAmountChanged);

    // Add unknown asset to the available cylinder
    _allAssets = [];
    _allAssets.addAll(widget.assets);
    _allAssets.sort((asset1, asset2) {
      return (asset1.name ?? "").compareTo(asset2.name ?? "");
    });

    _allAssets.add(Asset.createUnknown());

    super.initState();
  }

  @override
  void dispose() {
    amountTextController.dispose();
    super.dispose();
  }

  void onAmountChanged() {
    print("onAmountChanged text > ${amountTextController.text}");
    try {
      _pickedAmountLbs = double.parse(amountTextController.text);
    } catch (error) {
      _pickedAmountLbs = 0;
    }
  }

  @override
  String getTitle(MaterialGasInstallType type) {
    if (type == MaterialGasInstallType.Install) {
      return "Install";
    } else if (type == MaterialGasInstallType.Recovery) {
      return "Recovery";
    }
    return null;
  }

  String getActionButtonTitle(MaterialGasInstallType type) {
    if (type == MaterialGasInstallType.Install) {
      return "ADD INSTALL";
    } else if (type == MaterialGasInstallType.Recovery) {
      return "ADD RECOVERY";
    }
    return "SUBMIT";
  }

  Widget _buildOverlayContent(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(14),
      children: <Widget>[
        _buildTitle(context),
        SizedBox(
          height: 10,
        ),
        _buildInstallGasHeader(context, widget.currentAssetWorkedOn),
        Row(
          children: <Widget>[
            FormBuild.buildDropdown(
                isRequired: true,
                key: Key("SelectedCylinder"),
                source: (_allAssets ?? [])
                    .map((i) => Dropdown(name: i.name, id: i.assetID))
                    .toList(),
                label: "Select Cylinder",
                onValidator: (value) {
                  if (_pickedAsset == null) {
                    return "Required";
                  }
                },
                onChangedValue: (value) {
                  if (value is Dropdown) {
                    print(
                        "Select Cylinder > onChangedValue ${value.name} / ${value.id}");
                  }
                  Asset selectedAsset =
                      Asset(assetID: (value is Dropdown) ? value.id : 0);

//                  int pickedIndex = widget.assets.indexOf(selectedAsset);
                  int pickedIndex = _allAssets
                      .indexWhere((i) => i.assetID == selectedAsset.assetID);

                  print("pickedIndex ## $pickedIndex");
                  Asset fullSelectedAsset = _allAssets[pickedIndex];

                  print("fullSelectedAsset.id ${fullSelectedAsset.id}");
                  print(
                      "fullSelectedAsset.materialTypeID ${fullSelectedAsset.materialTypeID}");

                  setState(() {
                    _pickedAsset = fullSelectedAsset;
                  });
                })
          ],
        ),
        _buildInstallAmount(context),
        Row(
          children: <Widget>[
            FormBuild.buildDatePicker(
                onPressed: (value) {
                  print("Picked Date $value");
                  _pickedDateMaterialTransfer = value;
                },
                key: Key("DateMaterialTranferKey"),
                helper: "Date of Material Transfer")
          ],
        ),
        SizedBox(height: 12),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[_buildBottom(context)],
        )
      ],
    );
  }

  Widget _buildInstallAmount(BuildContext context) {
    return Row(
      children: <Widget>[
        FormBuild.buildTextField(
            textController: amountTextController,
            onValidated: (value) {
              if (value.isEmpty || value == null) {
                return "Required";
              }
              try {
                double amountEstimatedValue = double.parse(value);
              } catch (error) {
                return "Amount input is not valid";
              }
            },
            onSubmitted: (value) {
              print("ChooseAmountInKey > onSubmitted $value");
              double leakAmount = double.parse(value);
              if (leakAmount != null) {
                _pickedAmountLbs = leakAmount;
              }
            },
            inputType: TextInputType.text,
            key: Key("ChooseAmountInKey"),
            label: "Choose Amount (lbs)"),
      ],
    );
  }

  Widget _buildBottom(BuildContext context) {
    return AppButton(
      titleButton: getActionButtonTitle(widget.installType),
      onPressed: () {
        if (_formKey.currentState.validate()) {
          print("> validate");
          _formKey.currentState.save();

          String dateMaterialTransfer;
          if (_pickedDateMaterialTransfer != null) {
            dateMaterialTransfer = DateFormat(kShortTimeDateFormat)
                .format(_pickedDateMaterialTransfer);
          }
          print("_pickedAmountLbs $_pickedAmountLbs");
          print("_pickedAsset.id ${_pickedAsset.id}");
          print("_pickedAsset.materialTypeID ${_pickedAsset.materialTypeID}");
          print("_dateMaterialTransfer $dateMaterialTransfer");

          int materialTransferTypeID =
              MaterialTransfer.getMaterialGasInstallID(widget.installType);
          String materialTransferType =
              MaterialTransfer.getMaterialGasInstall(widget.installType);

          print("materialTransferTypeID $materialTransferTypeID");
          print("materialTransferType $materialTransferType");

          print("===> ServiceType > ${widget.serviceType}");
          // Add fixes
          // If it's service recover then put the selected cylinder to 'toAsset' and 'toAssetID'
          MaterialTransfer transfer;
          if (widget.serviceType == ServiceType.Shutdown &&
              materialTransferTypeID == 1) {
            transfer = MaterialTransfer(
                transferWeightLbs: _pickedAmountLbs,
                materialTransferTypeID: materialTransferTypeID,
                materialTransferType: materialTransferType,
                toAssetID: _pickedAsset.id,
                toAsset: _pickedAsset.name,
                fromAssetID: widget.currentAssetWorkedOn.id,
                fromAsset: widget.currentAssetWorkedOn.name,
                materialTypeID: widget.currentAssetWorkedOn.materialTypeID,
                transferDate: dateMaterialTransfer);
          } else if (widget.serviceType == ServiceType.ServiceAndLeakRepair) {
            if (materialTransferTypeID == 1) {
              transfer = MaterialTransfer(
                  transferWeightLbs: _pickedAmountLbs,
                  materialTransferTypeID: materialTransferTypeID,
                  materialTransferType: materialTransferType,
                  toAssetID: _pickedAsset.id,
                  toAsset: _pickedAsset.name,
                  fromAssetID: widget.currentAssetWorkedOn.id,
                  fromAsset: widget.currentAssetWorkedOn.name,
                materialTypeID: widget.currentAssetWorkedOn?.materialTypeID ?? 0,
                  transferDate: dateMaterialTransfer);
            } else if (materialTransferTypeID == 2) {
              transfer = MaterialTransfer(
                  transferWeightLbs: _pickedAmountLbs,
                  materialTransferTypeID: materialTransferTypeID,
                  materialTransferType: materialTransferType,
                  fromAsset: _pickedAsset.name,
                  fromAssetID: _pickedAsset.id,
                  toAssetID: widget.currentAssetWorkedOn.id,
                  toAsset: widget.currentAssetWorkedOn.name,
                  materialTypeID: widget.currentAssetWorkedOn?.materialTypeID ?? 0,
                  transferDate: dateMaterialTransfer);
            }
          }

          print("===> MaterialTransfer");
          print("===> _pickedAmountLbs : $_pickedAmountLbs");
          print("===> materialTransferTypeID : $materialTransferTypeID");
          print("===> materialTransferType : $materialTransferType");
          print("===> id : ${_pickedAsset.id}");
          print("===> name : ${_pickedAsset.name}");
          print("===> materialTypeID : ${_pickedAsset.materialTypeID}");
          print("===> dateMaterialTransfer : ${dateMaterialTransfer}");

          // Transmit the information to material transfer if not null
          if (transfer != null) {
            if (widget.delegate != null) {
              widget?.delegate(transfer);
            }
            Navigator.of(context).pop();
          }
        }
      },
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Container(
        child: Align(
      alignment: Alignment.topCenter,
      child: Row(
        children: <Widget>[
          Text(
            "Gas ${getTitle(widget.installType)}",
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .title
                .copyWith(color: AppColors.blueTurquoise),
          )
        ],
      ),
    ));
  }

  Widget _buildInstallGasHeader(BuildContext context, Asset selectedAsset) {
    print("_buildInstallGasHeader");
    return Align(
      alignment: Alignment.topLeft,
      child: (selectedAsset == null)
          ? Container()
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  child: Row(
                    children: <Widget>[
                      Text("Material type: ",
                          style: Theme.of(context)
                              .textTheme
                              .body1
                              .copyWith(fontWeight: FontWeight.bold)),
                      Text("${selectedAsset.materialType}",
                          style: Theme.of(context)
                              .textTheme
                              .body1
                              .copyWith(fontStyle: FontStyle.italic))
                    ],
                  ),
                ),
                Container(
                  child: Row(
                    children: <Widget>[
                      Text("Max gas capacity: ",
                          style: Theme.of(context)
                              .textTheme
                              .body1
                              .copyWith(fontWeight: FontWeight.bold)),
                      Text(
                          "${selectedAsset.maxGasCapacityLbs} ${selectedAsset.weightUnits ?? "Lbs"}",
                          style: Theme.of(context)
                              .textTheme
                              .body1
                              .copyWith(fontStyle: FontStyle.italic))
                    ],
                  ),
                ),
                Container(
                  child: Row(
                    children: <Widget>[
                      Text("Current gas capacity: ",
                          style: Theme.of(context)
                              .textTheme
                              .body1
                              .copyWith(fontWeight: FontWeight.bold)),
                      Text(
                          "${selectedAsset.currentGasWeightLbs} ${selectedAsset.weightUnits ?? "Lbs"}",
                          style: Theme.of(context)
                              .textTheme
                              .body1
                              .copyWith(fontStyle: FontStyle.italic))
                    ],
                  ),
                )
              ],
            ),
    );
  }

  // child: _buildOverlayContent(context),
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(key: _formKey, child: _buildOverlayContent(context)),
    );
  }
}
