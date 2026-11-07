import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fasta_deliveries_store/features/service_module/store/domain/models/service_model.dart';

class AddServiceScreen extends StatefulWidget {
  final ServiceModel? service;
  final int? serviceId;
  const AddServiceScreen({super.key, this.service, this.serviceId});

  @override
  State<AddServiceScreen> createState() => _AddServiceScreenState();
}

class _AddServiceScreenState extends State<AddServiceScreen>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}
