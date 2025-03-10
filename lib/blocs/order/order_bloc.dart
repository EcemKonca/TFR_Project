import 'package:flutter_bloc/flutter_bloc.dart';
import '../../services/api_service.dart';
import 'order_event.dart';
import 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final ApiService apiService;

  OrderBloc(this.apiService) : super(OrderInitial()) {
    on<FetchOrders>((event, emit) async {
      emit(OrderLoading());
      try {
        final orders = await apiService.getOrders();
        emit(OrderLoaded(orders));
      } catch (e) {
        emit(OrderError("An error occurred while loading orders: $e"));
      }
    });
  }
}