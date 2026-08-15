import 'package:flutter/material.dart';
import 'package:showave/models/cart_item.dart';

class Order {
  final String id;
  final Status orderStatus;
  final List<CartItem> items;
  final double total;
  final DateTime createdAt;

  Order({
    required this.id,
    required this.orderStatus,
    required this.items,
    required this.total,
    required this.createdAt,
  });

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is Order && runtimeType == other.runtimeType && id == other.id;
  }

  @override
  String toString() {
    return "Order Id: $id | Order Total: $total | Order Status: $orderStatus";
  }

  @override
  int get hashCode => id.hashCode;

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json["id"] as String,
      orderStatus: Status.fromString(json['status']),
      items: (json['items'] as List<CartItem>),
      total: json['total'] as double,
      createdAt: DateTime.tryParse(json['createdAt']) ?? DateTime.now(),
    );
  }
}

enum Status {
  pending,
  processing,
  delivered,
  shipping,
  cancelled;

  String get label => switch (this) {
    Status.pending => 'Pending',
    Status.processing => 'Processing',
    Status.delivered => 'Delivered',
    Status.shipping => 'Shipping',
    Status.cancelled => 'Cancelled',
  };

  static Status fromString(String value) {
    return Status.values.firstWhere(
      (e) => e.name == value,
      orElse: () => Status.pending,
    );
  }

  Color get chipColor => switch (this) {
    Status.pending => Colors.orange,
    Status.processing => Colors.blue,
    Status.delivered => Colors.green,
    Status.shipping => Colors.purple,
    Status.cancelled => Colors.red,
  };
  Color get chipBgColor => switch (this) {
    Status.pending => Colors.orange.shade100,
    Status.processing => Colors.blue.shade100,
    Status.delivered => Colors.green.shade100,
    Status.shipping => Colors.purple.shade100,
    Status.cancelled => Colors.red.shade100,
  };
}
