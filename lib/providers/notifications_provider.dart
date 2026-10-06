import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:medicine_system/models/notification_model.dart';
import 'package:medicine_system/models/paginated_response.dart';
import 'package:medicine_system/services/repository/notifications_repository.dart';
import 'package:medicine_system/utils/app_snack_bar.dart';

final notificationsProvider = StateNotifierProvider<NotificationsNotifier, NotificationsState>((ref) {
  return NotificationsNotifier(NotificationsRepository());
});

class NotificationsState {
  final bool isLoading;
  final List<NotificationModel> notifications;
  final String? error;
  final PaginatedResponse<NotificationModel>? paginatedData;
  final int itemsPerPage;
  final String searchQuery;

  NotificationsState({
    this.isLoading = false,
    this.notifications = const [],
    this.error,
    this.paginatedData,
    this.itemsPerPage = 10,
    this.searchQuery = '',
  });

  NotificationsState copyWith({
    bool? isLoading,
    List<NotificationModel>? notifications,
    String? error,
    PaginatedResponse<NotificationModel>? paginatedData,
    int? itemsPerPage,
    String? searchQuery,
  }) {
    return NotificationsState(
      isLoading: isLoading ?? this.isLoading,
      notifications: notifications ?? this.notifications,
      error: error,
      paginatedData: paginatedData ?? this.paginatedData,
      itemsPerPage: itemsPerPage ?? this.itemsPerPage,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

class NotificationsNotifier extends StateNotifier<NotificationsState> {
  final NotificationsRepository repository;
  Timer? _debounce;

  NotificationsNotifier(this.repository) : super(NotificationsState()) {
    fetchNotifications();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  Future<void> fetchNotifications({int page = 1, bool isLoadMore = false}) async {
    if (isLoadMore) {
      if (state.paginatedData?.meta?.currentPage == state.paginatedData?.meta?.lastPage) {
        return;
      }
    } else {
      state = state.copyWith(isLoading: true, error: null);
    }

    try {
      final response = await repository.fetchNotifications(
        page: page,
        perPage: state.itemsPerPage,
        search: state.searchQuery,
      );

      if (response != null && response['success'] == true && response['data'] != null) {
        final paginatedResponse = PaginatedResponse<NotificationModel>.fromJson(
          response['data'],
          (json) => NotificationModel.fromJson(json),
        );
        
        state = state.copyWith(
          isLoading: false,
          notifications: isLoadMore 
              ? [...state.notifications, ...paginatedResponse.data]
              : paginatedResponse.data,
          paginatedData: paginatedResponse,
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          error: response?['message'] ?? 'No notifications found.',
          notifications: [],
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  void updateItemsPerPage(int count) {
    state = state.copyWith(itemsPerPage: count);
    fetchNotifications();
  }

  void updateSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      fetchNotifications();
    });
  }
}
