import 'package:get/get_connect/connect.dart';
import 'package:fasta_deliveries_vendor/features/business/domain/models/business_plan_body.dart';
import 'package:fasta_deliveries_vendor/interface/repository_interface.dart';

abstract class BusinessRepoInterface<T> implements RepositoryInterface<T> {
  Future<Response> setUpBusinessPlan(BusinessPlanBody businessPlanBody);
}