enum OrderStatus { pending, returning, delivered, canceled }

OrderStatus getStatusType(String? status) {
  switch (status) {
    case "Pending (In the courier)":
      return OrderStatus.pending;
    case "Returning":
      return OrderStatus.returning;
    case "Delivered":
      return OrderStatus.delivered;
    default:
      return OrderStatus.canceled;
  }
}
