import 'package:fake_store/network/router/dio/dio_router.dart';
import 'package:fake_store/network/router/network_router.dart';
import 'package:riverpod/riverpod.dart';

final networkProvider = Provider<NetworkRouter>((ref) => DioRouter());
